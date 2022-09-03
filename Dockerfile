FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-devel

RUN conda install -y faiss-gpu scikit-learn pandas flake8 yapf isort yacs gdown future -c conda-forge

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple opencv-python-headless scipy matplotlib tensorboard

RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc
