FROM scratch

ARG EXECUTABLE

ADD $EXECUTABLE /gotrygo

EXPOSE 80

CMD ["/gotrygo"]
