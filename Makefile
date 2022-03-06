DISTRIBUTION_ID:=E8PEBV28VFB8R
BUCKET_NAME:=hosted.vranix.com

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[/.a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

@PHONY: build
build: ## Bulid latex resume to pdf
	pdflatex resume.tex

@PHONY: deploy
deploy: build ## Deploy resume to s3 where it is linked to from vranix.com
	aws s3 cp --acl "public-read" resume.pdf s3://${BUCKET_NAME}/shaw-vrana-resume.pdf
	aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths /shaw-vrana-resume.pdf
