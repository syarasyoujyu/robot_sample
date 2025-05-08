# Docker image
# https://hub.docker.com/r/airobotbook/ros2-desktop-ai-robot-book-humble
# 「ROS2とPythonで作って学ぶAIロボット入門」の教材一式を提供するDockerイメージ
FROM airobotbook/ros2-desktop-ai-robot-book-humble:latest


RUN apt -y update
# && apt -y upgrade
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt -y install --no-install-recommends \
    # # Necessary for pip install
    # gcc g++ libc-dev \
    # For development and debug (procps: `free -h`)
    bash curl git net-tools vim procps \
    # # For scikit-learn (scipy)
    # gfortran libopenblas-dev liblapack-dev \
    # # For opencv-python
    # libopencv-dev \
    # # For parapara-anime
    # xvfb \
    # # For building pafprocess module
    # swig \
    # # For notebook to pdf https://stackoverflow.com/questions/29156653/ipython-jupyter-problems-saving-notebook-as-pdf
    # texlive texlive-latex-extra pandoc \
    # For enabling jupyter notebook to use xelatex and output pdf https://stackoverflow.com/questions/52300242/solving-500-internal-server-error-nbconvert-failed-xelatex-not-found-in-path
    texlive-xetex texlive-fonts-recommended texlive-plain-generic \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# for updating python module
RUN pip install --upgrade pip

ARG WORKING_DIRECTORY
WORKDIR /${WORKING_DIRECTORY}

# Install pip modules
COPY requirements.txt ./
RUN apt -y remove python3-blinker
RUN pip install -r requirements.txt

# Set jupyter conf for supervisor
COPY jupyter.conf /etc/supervisor/conf.d/jupyter.conf

# # NOTE: pytorch family
# RUN pip3 install torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cpu