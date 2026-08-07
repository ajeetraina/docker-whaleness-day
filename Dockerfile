# The classic docker/whalesay image, rebuilt for Docker Hub.
#
# The sbx workflow (see whalesay.sh / README) is the star of this repo, but
# this Dockerfile lets folks run the whale the traditional way too:
#     docker run ajeetraina777/whaleness-day boo
FROM alpine
RUN apk add --no-cache perl
COPY cowsay /usr/local/bin/cowsay
COPY docker.cow /usr/local/share/cows/default.cow
ENTRYPOINT ["/usr/local/bin/cowsay"]
CMD ["Happy Whaleness Day"]
