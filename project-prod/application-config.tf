locals {
    domains = {
        author = ["${var.domain_prefix}.author.eqbs.gcp.onsdigital.uk","author.eqbs.gcp.onsdigital.uk"]
        publisher = ["${var.domain_prefix}.publisher.eqbs.gcp.onsdigital.uk"]
        validator = ["${var.domain_prefix}.validator.eqbs.gcp.onsdigital.uk"]
        registry = ["${var.domain_prefix}.registry.eqbs.gcp.onsdigital.uk"]
        launcher = ["${var.domain_prefix}.author-launcher.eqbs.gcp.onsdigital.uk"]
        runner = ["${var.domain_prefix}.author-runner.eqbs.gcp.onsdigital.uk"]
        extract-questions = ["${var.domain_prefix}.extract-questions.eqbs.gcp.onsdigital.uk"]
    }
    
    applications = {
        "runner" = {
            name = "eq-author-runner"
            image = "eu.gcr.io/ons-eqbs-images/eq-author-runner:v3.79.0"
            container_port = "5000"
            hosts = ["*.author-runner.eqbs.gcp.onsdigital.uk"]
            default_service = "runner"
            path_rules = []
            envs = {
                EQ_STORAGE_BACKEND="datastore"
                EQ_REDIS_HOST="${module.memorystore.host}"
                EQ_REDIS_PORT="6379"
                EQ_SUBMITTED_RESPONSES_TABLE_NAME="author-runner-submitted-responses"
                EQ_QUESTIONNAIRE_STATE_TABLE_NAME="author-runner-questionnaire-state"
                EQ_SESSION_TABLE_NAME="author-runner-session"
                EQ_USED_JTI_CLAIM_TABLE_NAME="author-runner-used-jti-claim"
                EQ_SECRETS_FILE="dev-secrets.yml"
                EQ_KEYS_FILE="dev-keys.yml"
                EQ_RABBITMQ_ENABLED="False"
                EQ_RABBITMQ_HOST="rabbit"
                EQ_RABBITMQ_HOST_SECONDARY="rabbit"
                EQ_SUBMISSION_BACKEND="log"
                EQ_ENABLE_LIVE_RELOAD="False"
                EQ_ENABLE_SECURE_SESSION_COOKIE="False"
                EQ_SESSION_TIMEOUT_SECONDS="19200"
                EQ_FEEDBACK_BACKEND="log"
                EQ_PUBLISHER_BACKEND="log"
                EQ_NEW_RELIC_ENABLED="False"
                EQ_INDIVIDUAL_RESPONSE_LIMIT="75"
                EQ_INDIVIDUAL_RESPONSE_POSTAL_DEADLINE="2021-04-28T14:00:00+00:00"
                EQ_FEEDBACK_LIMIT="10"
                ADDRESS_LOOKUP_API_AUTH_ENABLED="False"
                ADDRESS_LOOKUP_API_AUTH_TOKEN_LEEWAY_IN_SECONDS="300"
                ADDRESS_LOOKUP_API_URL="https://whitelodge-ai-api.census-gcp.onsdigital.uk"
                COOKIE_SETTINGS_URL="#"
                EQ_SUBMISSION_CONFIRMATION_BACKEND="log"
                CONFIRMATION_EMAIL_LIMIT="10"
                EQ_GCS_SUBMISSION_BUCKET_ID="#"
                HTTP_KEEP_ALIVE="650"
                WEB_SERVER_TYPE="gunicorn-async"
                WEB_SERVER_WORKERS="3"
                WEB_SERVER_THREADS="10"
                WEB_SERVER_UWSGI_ASYNC_CORES="10"
                GUNICORN_CMD_ARGS="-c gunicorn_config.py"
                DATASTORE_USE_GRPC="False"
            }
            "secrets" = {}
        },

        "launcher" = {
            name = "eq-author-launcher"
            image = "eu.gcr.io/ons-eqbs-images/eq-author-launcher:v1.3.0"
            container_port = "8000"
            hosts = ["*.author-launcher.eqbs.gcp.onsdigital.uk"]
            default_service = "launcher"
            path_rules = []
            envs = {
                SURVEY_RUNNER_SCHEMA_URL="https://${var.domain_prefix}.author-runner.eqbs.gcp.onsdigital.uk"
                SURVEY_RUNNER_URL="https://${var.domain_prefix}.author-runner.eqbs.gcp.onsdigital.uk"
            }
            "secrets" = {}
        },

        "registry" = {
            name = "eq-questionnaire-registry"
            image = "eu.gcr.io/ons-eqbs-images/eq-questionnaire-registry:4a16885"
            container_port = "8080"
            hosts = ["*.registry.eqbs.gcp.onsdigital.uk"]
            default_service = "registry"
            path_rules = []
            envs = {
                REGISTRY_DATABASE_SOURCE="firestore"
                PUBLISHER_URL="https://${var.domain_prefix}.author.eqbs.gcp.onsdigital.uk/convert/"
            }
            "secrets" = {}
        },

        "author" = {
            name = "eq-author"
            image = "eu.gcr.io/ons-eqbs-images/eq-author:v1.4.17"
            container_port = "3000"
            hosts = ["*.author.eqbs.gcp.onsdigital.uk","author.eqbs.gcp.onsdigital.uk"]
            default_service = "author"
            path_rules = [{
                paths = ["/graphql","/signIn","/launch/*","/convert/*","/import","/export/*","/status"]
                service = "author-api"
            }]
            "envs" = {
                REACT_APP_API_URL="/graphql"
                REACT_APP_SIGN_IN_URL="/signIn"
                REACT_APP_LAUNCH_URL="/launch"
            }
            "secrets" = {
                REACT_APP_FIREBASE_PROJECT_ID="react_app_firebase_project_id"
                REACT_APP_FIREBASE_API_KEY="react_app_firebase_api_key"
            }
        },

        "author-api" = {
            name = "eq-author-api"
            image = "eu.gcr.io/ons-eqbs-images/eq-author-api:v1.4.17"
            container_port = "4000"
            hosts = ["*.author-api.eqbs.gcp.onsdigital.uk"]
            default_service = "author-api"
            path_rules = []
            envs = {
                ALLOWED_EMAIL_LIST="@ons.gov.uk,@ext.ons.gov.uk,@nisra.gov.uk"
                ENABLE_IMPORT="true"
                PUBLISHER_URL="https://${var.domain_prefix}.author.eqbs.gcp.onsdigital.uk/convert/"
                CONVERSION_URL="https://${var.domain_prefix}.publisher.eqbs.gcp.onsdigital.uk/publish/"
                RUNNER_SESSION_URL="https://${var.domain_prefix}.author-runner.eqbs.gcp.onsdigital.uk/session?token="
                SURVEY_REGISTER_URL="https://${var.domain_prefix}.registry.dev.eq.ons.digital/submit/"
                CORS_WHITELIST="https://${var.domain_prefix}.author.eqbs.gcp.onsdigital.uk"
                REDIS_DOMAIN_NAME="${module.memorystore.host}"
                REDIS_PORT="6379"
                "DATABASE"="firestore"
            }
            "secrets" = {
                FIREBASE_PROJECT_ID=="react_app_firebase_project_id"
            }
        },

        "extract-questions" = {
            name = "eq-extract-questions"
            image = "eu.gcr.io/ons-eqbs-images/eq-extract-questions:0a438fe"
            container_port = "3000"
            hosts = ["*.extract-questions.eqbs.gcp.onsdigital.uk"]
            default_service = "extract-questions"
            path_rules = []
            envs = {
                AUTHOR_SCHEMA_URL="https://prod-author.prod.eq.ons.digital/export/"
                RUNNER_SCHEMA_URL="https://prod-publisher.prod.eq.ons.digital/publish/"
            }
            "secrets" = {}
        },

        "publisher" = {
            name = "eq-publisher"
            image = "eu.gcr.io/ons-eqbs-images/eq-publisher:v1.0.3"
            container_port = "9000"
            hosts = ["*.publisher.eqbs.gcp.onsdigital.uk"]
            default_service = "publisher"
            path_rules = []
            envs = {}
            "secrets" = {}
        },

        "validator" = {
            name = "eq-questionnaire-validator"
            image = "eu.gcr.io/ons-eqbs-images/eq-questionnaire-validator:5e4ee78"
            container_port = "5000"
            hosts = ["*.validator.eqbs.gcp.onsdigital.uk"]
            default_service = "validator"
            path_rules = []
            envs = {}
            "secrets" = {}
        }
    }
}