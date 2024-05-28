FROM fedora:latest

# Install required packages
RUN dnf -y update && \
    dnf -y install dnf-plugins-core && \
    echo -e "[mongodb-org]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mongodb-org-4.4.repo && \
    dnf -y install nginx jq mongodb-mongosh && \
    dnf clean all

# Copy the script into the container
COPY generate_html.sh /usr/local/bin/generate_html.sh

# Make the script executable
RUN chmod +x /usr/local/bin/generate_html.sh

# Create an empty OpenSSL configuration file
RUN echo "" > /etc/ssl/openssl.cnf

# Set the environment variable to use the empty OpenSSL configuration file
ENV OPENSSL_CONF=/etc/ssl/openssl.cnf

# Expose port 80
EXPOSE 80

# Run the script and start nginx
CMD ["/bin/bash", "-c", "/usr/local/bin/generate_html.sh && nginx -g 'daemon off;'"]

