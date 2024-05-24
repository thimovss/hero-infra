FROM hashicorp/terraform:1.8.4
RUN apk add --no-cache bash python3 py3-pip
COPY . .
RUN chmod +x exec.sh
ENTRYPOINT ["./exec.sh"]