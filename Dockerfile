FROM olliv/cobolcgi

LABEL name "cobol-hello-world"

WORKDIR /var/www/cobol
COPY cobol-hello-world /var/www/cobol
RUN cobc -x -free cow.cbl `ls -d controllers/*` -o the.cow

EXPOSE 80
CMD ["/run.sh"]
