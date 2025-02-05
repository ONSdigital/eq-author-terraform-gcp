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
            image = "${var.application_image_repository}/eq-author-runner:v14.9.1"
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
            image = "${var.application_image_repository}/eq-author-launcher:d231337"
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
            image = "${var.application_image_repository}/eq-questionnaire-registry:aae9dbf"
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
            image = "${var.application_image_repository}/eq-author:v3.0.51"
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
                REACT_APP_FEATURE_FLAGS="hub"
            }
            "secrets" = {
                REACT_APP_FIREBASE_PROJECT_ID="react_app_firebase_project_id"
                REACT_APP_FIREBASE_API_KEY="react_app_firebase_api_key"
            }
        },

        "author-api" = {
            name = "eq-author-api"
            image = "${var.application_image_repository}/eq-author-api:v3.0.51"
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
                CORS_WHITELIST="https://${var.domain_prefix}.author.eqbs.gcp.onsdigital.uk,https://author.eqbs.gcp.onsdigital.uk"
                REDIS_DOMAIN_NAME="${module.memorystore.host}"
                REDIS_PORT="6379"
                "DATABASE"="firestore"
            }
            "secrets" = {
                FIREBASE_PROJECT_ID="react_app_firebase_project_id"
            }
        },

        "extract-questions" = {
            name = "eq-extract-questions"
            image = "${var.application_image_repository}/eq-extract-questions:v0.0.12"
            container_port = "3050"
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
            image = "${var.application_image_repository}/eq-publisher:v1.0.78"
            container_port = "9000"
            hosts = ["*.publisher.eqbs.gcp.onsdigital.uk"]
            default_service = "publisher"
            path_rules = []
            envs = {}
            "secrets" = {}
        },

        "validator" = {
            name = "eq-questionnaire-validator"
            image = "${var.application_image_repository}/eq-questionnaire-validator:f99d228"
            container_port = "5000"
            hosts = ["*.validator.eqbs.gcp.onsdigital.uk"]
            default_service = "validator"
            path_rules = []
            envs = {}
            "secrets" = {}
        }
    }
}