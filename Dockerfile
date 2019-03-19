FROM ignacio82/imremoter
LABEL maintainer="Ignacio Martinez <ignacio@protonmail.com>"
RUN apt-get update \
    && apt-get install -t unstable -y --no-install-recommends \
           libxml2-dev libssl-dev libcurl4-openssl-dev

RUN R -e "remotes::install_cran('drat')"
RUN R -e "drat::addRepo(account = 'Ignacio', alturl = 'https://drat.ignacio.website/') ; install.packages('IMS3')"

RUN mkdir -p /root/.ssh
VOLUME [ "/root/.ssh" ]
RUN  echo "    IdentityFile /root/.ssh/id_rsa" >> /etc/ssh/ssh_config


