ARG ARG_WORKSPACE_BASE_IMAGE="khulnasoft/ml-workspace:latest"
FROM $ARG_WORKSPACE_BASE_IMAGE
ARG ARG_WORKSPACE_BASE_IMAGE

ARG ARG_WORKSPACE_FLAVOR="gpu"
ENV WORKSPACE_FLAVOR=$ARG_WORKSPACE_FLAVOR

USER root

### NVIDIA CUDA TOOLKIT ###
ENV CUDA_VERSION=12.6.3
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    curl -fsSLo /tmp/cuda-keyring.deb \
        https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i /tmp/cuda-keyring.deb && \
    rm /tmp/cuda-keyring.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends cuda-toolkit-12-6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# JAX's local CUDA extra uses the cuDNN library installed by TensorFlow's pip extra.
ENV CUDA_HOME=/usr/local/cuda \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/conda/lib/python3.11/site-packages/nvidia/cudnn/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/opt/conda/lib \
    LIBRARY_PATH=/usr/local/cuda/lib64/stubs

ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    NVIDIA_REQUIRE_CUDA="cuda>=12.6"

### GPU DATA SCIENCE LIBRARIES ###
RUN apt-get update && \
    apt-get install -y --no-install-recommends libomp-dev libopenblas-base && \
    pip uninstall -y torch torchvision torchaudio && \
    pip install --no-cache-dir \
        --index-url https://download.pytorch.org/whl/cu126 \
        torch==2.6.0+cu126 torchvision==0.21.0+cu126 torchaudio==2.6.0+cu126 && \
    pip uninstall -y tensorflow tensorflow-cpu intel-tensorflow && \
    pip install --no-cache-dir "tensorflow[and-cuda]==2.19.*" && \
    pip install --no-cache-dir \
        cupy-cuda12x pycuda gpustat py3nvml gputil scikit-cuda && \
    pip uninstall -y onnxruntime && \
    pip install --no-cache-dir onnxruntime-gpu==1.20.* && \
    pip install --no-cache-dir --upgrade "jax[cuda12-local]==0.5.3" nvidia-ml-py ipyexperiments && \
    clean-layer.sh

ENV TF_FORCE_GPU_ALLOW_GROWTH=true

### CONFIGURATION ###
ARG ARG_WORKSPACE_VERSION="latest"
ENV WORKSPACE_VERSION=$ARG_WORKSPACE_VERSION

ARG ARG_BUILD_DATE="unknown"
ARG ARG_VCS_REF="unknown"

LABEL \
    "workspace.version"=$WORKSPACE_VERSION \
    "workspace.flavor"=$WORKSPACE_FLAVOR \
    "workspace.baseimage"=$ARG_WORKSPACE_BASE_IMAGE \
    "org.opencontainers.image.version"=$WORKSPACE_VERSION \
    "org.opencontainers.image.revision"=$ARG_VCS_REF \
    "org.opencontainers.image.created"=$ARG_BUILD_DATE \
    "org.label-schema.version"=$WORKSPACE_VERSION \
    "org.label-schema.vcs-ref"=$ARG_VCS_REF \
    "org.label-schema.build-date"=$ARG_BUILD_DATE

USER $NB_USER
