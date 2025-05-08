FROM ghcr.io/msd-live/jupyter/python-notebook:latest as builder

FROM builder AS tethys
RUN git clone https://github.com/JGCRI/gcamreader.git /usr/local/gcamreader
RUN cd /usr/local/gcamreader && sed -i 's/requests~=/requests>=/g' setup.py \
    && sed -i 's/requests~=/requests>=/g' requirements.txt 
RUN pip3 install -e /usr/local/gcamreader
RUN git clone --branch source-disagg https://github.com/JGCRI/tethys.git /usr/local/tethys
RUN cd /usr/local/tethys && sed -i 's/gcamreader>=1.2.5/gcamreader>=1.4.0/g' setup.py \
    && sed -i 's/gcamreader>=1.2.5/gcamreader>=1.4.0/g' requirements.txt 
RUN pip3 install -e /usr/local/tethys
RUN pip3 install --force-reinstall xarray==2024.5.0
RUN pip3 install --force-reinstall numpy==1.26.4
RUN apt-get -y update && apt-get install -y openjdk-11-jdk-headless openjdk-11-jre-headless
COPY notebooks /home/jovyan/notebooks