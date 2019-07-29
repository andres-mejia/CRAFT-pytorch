FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-devel

WORKDIR /workspace/

# install basics
RUN apt-get update -y
RUN apt-get install -y git curl ca-certificates bzip2 cmake tree htop bmon iotop sox libsox-dev libsox-fmt-all vim libglib2.0-0 libsm6 libxext6 libxrender-dev

# install python deps
RUN pip install cython visdom cffi tensorboardX wget

# install warp-CTC
ENV CUDA_HOME=/usr/local/cuda
RUN git clone https://github.com/SeanNaren/warp-ctc.git
RUN cd warp-ctc; mkdir build; cd build; cmake ..; make
RUN cd warp-ctc; cd pytorch_binding; python setup.py install

# install apex
RUN git clone --recursive https://github.com/NVIDIA/apex.git
RUN cd apex; pip install .

# install craft
ADD . /workspace/craft
RUN cd craft; pip install -r requirements.txt

# launch jupiter
RUN pip install jupyter
RUN mkdir data; mkdir notebooks;
CMD jupyter-notebook --ip="*" --no-browser --allow-root

ENV HOST=0.0.0.0 PORT=8888
EXPOSE ${PORT}