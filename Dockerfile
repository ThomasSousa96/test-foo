ARG BASE_IMAGE_TAG
FROM golang:$BASE_IMAGE_TAG

CMD ["echo", "hello"]
