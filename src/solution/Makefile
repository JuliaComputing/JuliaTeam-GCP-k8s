include ../app.Makefile
include ../crd.Makefile
include ../gcloud.Makefile
include ../var.Makefile

TAG ?= latest

$(info ---- TAG = $(TAG))
$(info ---- TEAMSERVER_VERSION = $(TEAMSERVER_VERSION))

APP_DEPLOYER_IMAGE ?= $(REGISTRY)/juliateam-app/deployer:$(TAG)
NAME ?= juliateam-app-1

ifdef IMAGE_JULIATEAM_APP
  IMAGE_JULIATEAM_APP_FIELD = , "IMAGE_JULIATEAM_APP": "$(IMAGE_JULIATEAM_APP)"
endif

ifdef JULIATEAM_APP_JULIATEAM_HOSTNAME
  JULIATEAM_APP_JULIATEAM_HOSTNAME_FIELD = , "JULIATEAM_APP_JULIATEAM_HOSTNAME": "$(JULIATEAM_APP_JULIATEAM_HOSTNAME)"
endif

ifdef JULIATEAM_APP_JC_AUTH_TOKEN
  JULIATEAM_APP_JC_AUTH_TOKEN_FIELD = , "JULIATEAM_APP_JC_AUTH_TOKEN": "$(JULIATEAM_APP_JC_AUTH_TOKEN)"
endif

APP_PARAMETERS ?= { \
  "APP_INSTANCE_NAME": "$(NAME)", \
  "NAMESPACE": "$(NAMESPACE)" \
  $(IMAGE_JULIATEAM_APP_FIELD) \
  $(JULIATEAM_APP_JULIATEAM_HOSTNAME_FIELD) \
  $(JULIATEAM_APP_JC_AUTH_TOKEN_FIELD) \
}

TESTER_IMAGE ?= $(REGISTRY)/juliateam-app/tester:$(TAG)


app/build:: .build/juliateam-app/deployer \
            .build/juliateam-app/juliateam-app \
            .build/juliateam-app/tester


.build/juliateam-app: | .build
	mkdir -p "$@"


.build/juliateam-app/deployer: deployer/* \
                       manifest/* \
                       schema.yaml \
                       .build/var/APP_DEPLOYER_IMAGE \
                       .build/var/MARKETPLACE_TOOLS_TAG \
                       .build/var/REGISTRY \
                       .build/var/TAG \
                       | .build/juliateam-app
	docker build \
	    --build-arg REGISTRY="$(REGISTRY)/juliateam-app" \
	    --build-arg TAG="$(TAG)" \
	    --build-arg MARKETPLACE_TOOLS_TAG="$(MARKETPLACE_TOOLS_TAG)" \
	    --tag "$(APP_DEPLOYER_IMAGE)" \
	    -f deployer/Dockerfile \
	    .
	docker push "$(APP_DEPLOYER_IMAGE)"
	@touch "$@"


.build/juliateam-app/juliateam-app: .build/var/REGISTRY \
                              .build/var/TAG \
                              | .build/juliateam-app

	docker pull gcr.io/juliarun-cloud/gcpteamsrvr:$(TEAMSERVER_VERSION)
	docker tag gcr.io/juliarun-cloud/gcpteamsrvr:$(TEAMSERVER_VERSION) \
	    "$(REGISTRY)/juliateam-app:$(TAG)"
	docker push "$(REGISTRY)/juliateam-app:$(TAG)"


.build/juliateam-app/tester: .build/var/TESTER_IMAGE \
                          $(shell find apptest -type f) \
                          | .build/juliateam-app
	$(call print_target,$@)
	cd apptest/tester \
	    && docker build --tag "$(TESTER_IMAGE)" .
	docker push "$(TESTER_IMAGE)"
	@touch "$@"
