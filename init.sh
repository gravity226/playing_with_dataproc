#!/usr/bin/env bash

gsutil -m cp -r gs://dataproc-initialization-actions/conda/bootstrap-conda.sh .
gsutil -m cp -r gs://dataproc-initialization-actions/conda/install-conda-env.sh .

chmod 755 ./*conda*.sh

# Install Miniconda / conda
./bootstrap-conda.sh

# Update conda root environment with specific packages in pip and conda
CONDA_PACKAGES='pandas scikit-learn'
PIP_PACKAGES='tqdm'

CONDA_PACKAGES=$CONDA_PACKAGES PIP_PACKAGES=$PIP_PACKAGES ./install-conda-env.sh
