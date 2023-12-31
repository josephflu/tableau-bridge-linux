FROM docker.io/redhat/ubi8:8.7

RUN yum update -y & yum install -y wget git unzip
# create user
RUN groupadd --system --gid 1000 tableau &&  \
    adduser --system --gid 1000 --uid 1000 --shell /bin/bash --home /home/tableau tableau

RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq

WORKDIR /home/tableau
RUN mkdir -p /home/tableau/bridge_rpm

COPY source.yml .
RUN git clone --depth 1 https://github.com/tableau/container_image_builder.git

RUN sed -i "/\bDRIVERS=\b/d" container_image_builder/variables.sh
RUN sed -i "/\bOS_TYPE=\b/d" container_image_builder/variables.sh

RUN yq '.bridge.db_drivers | join(",")' source.yml > vars.txt &&  \
    echo "DRIVERS=$(cat vars.txt)" >> container_image_builder/variables.sh && \
    echo 'OS_TYPE="rhel8"' >> container_image_builder/variables.sh

RUN cd container_image_builder && \
    rm -rf /app/container_image_builder/build/drivers/files/* && \
    ./download.sh

RUN export DRIVERS="DRIVERS=$(cat vars.txt)" && \
    export OS_TYPE="rhel8" && \
    cd container_image_builder && \
    build/build.sh

COPY bridge_rpm /home/tableau/bridge_rpm
RUN cd /home/tableau/bridge_rpm/ && ACCEPT_EULA=y yum localinstall -y *.rpm && rm -rf *.rpm

COPY start-bridgeclient.sh .
RUN chmod +x start-bridgeclient.sh && \
    chown -R tableau:tableau /home/tableau

USER tableau

CMD ["./start-bridgeclient.sh"]
