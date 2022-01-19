#!/bin/bash
#
# Build and upload the Singularity containers needed
# for this project:
#
#   * plinkr
#   * ormr
#   * gcaer
#
# Usage:
#
#   ./90_upload_singularity_containers.sh
#   ./scripts/90_upload_singularity_containers.sh
#

mousepad \
  ~/GitHubs/plinkr/DESCRIPTION \
  ~/GitHubs/plinkr/Singularity \
  ~/GitHubs/plinkr/scripts/build_singularity_container.sh \
  ~/GitHubs/ormr/DESCRIPTION \
  ~/GitHubs/ormr/Singularity \
  ~/GitHubs/ormr/scripts/build_singularity_container.sh \
  ~/GitHubs/gcaer/DESCRIPTION \
  ~/GitHubs/gcaer/Singularity \
  ~/GitHubs/gcaer/scripts/build_singularity_container.sh

#cd ~/GitHubs/plinkr
#rm -f plinkr.sif
#./scripts/build_singularity_container.sh
#./scripts/upload_singularity_container.sh

cd ~/GitHubs/ormr
rm -f ormr.sif
./scripts/build_singularity_container.sh
./scripts/upload_singularity_container.sh
