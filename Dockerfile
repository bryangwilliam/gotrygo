FROM scratch

ARG EXECUTABLE

ADD $EXECUTABLE /gotrygo

CMD ["/gotrygo"]
