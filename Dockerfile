ARG BASE_IMAGE_TAG
FROM golang:$BASE_IMAGE_TAG

RUN echo "AAA"

RUN echo "BBB"
CMD ["echo", "hello"]
