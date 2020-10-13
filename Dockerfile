FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y install --no-install-recommends git subversion gcc g++ make wget gfortran patch pkg-config file
RUN apt-get -y install --no-install-recommends libgfortran-5-dev libblas-dev liblapack-dev libmetis-dev libnauty2-dev
RUN apt-get -y install --no-install-recommends ca-certificates

RUN git clone https://github.com/coin-or/coinbrew /var/coin-or
WORKDIR /var/coin-or
RUN ./coinbrew fetch COIN-OR-OptimizationSuite@stable/1.9 --skip="ThirdParty/Blas ThirdParty/Lapack ThirdParty/Metis" --no-prompt
RUN ./coinbrew build  COIN-OR-OptimizationSuite --skip="ThirdParty/Blas ThirdParty/Lapack ThirdParty/Metis" --no-prompt --prefix=/usr

## Install Chrome
RUN apt update
RUN apt-get autoclean
RUN apt install -y curl unzip
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN apt install -y /chrome.deb
RUN rm /chrome.deb

## Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/85.0.4183.87/chromedriver_linux64.zip -o chromedriver.zip
RUN unzip chromedriver.zip
RUN mv chromedriver /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver

## Install dependencies
RUN apt install -y python3 python3-pip
RUN pip3 install --no-cache --upgrade pip pandas selenium

RUN apt-get install --no-install-recommends -y numactl libssl1.1
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade sasoptpy cylp flask frozen-flask pillow

CMD echo 'Ready'
