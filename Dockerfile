FROM rocker/tidyverse
RUN apt-get update
RUN apt-get install r-base r-base-dev -y
# Install other R packages
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('infer')"
RUN Rscript -e "install.packages('ggthemes')"
RUN Rscript -e "install.packages('docopt')"
RUN Rscript -e "install.packages('gridExtra')"
RUN Rscript -e "install.packages('cowplot')"
RUN Rscript -e "install.packages('docopt')"
RUN Rscript -e "install.packages('testthat')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('rmarkdown')"

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda update -n base -c defaults conda

ENV PATH="/opt/conda/bin:${PATH}"

RUN conda install -c anaconda docopt -y
RUN conda install -c anaconda requests -y
RUN conda install -c conda-forge pytest -y
RUN conda install -c conda-forge altair vega_datasets -y

RUN apt-get update && apt install -y chromium && apt-get install -y libnss3 && apt-get install unzip

RUN wget -q "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip && chown root:root /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver

RUN conda install selenium -y

CMD ["/bin/bash"]