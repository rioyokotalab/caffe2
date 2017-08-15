for file in `git grep -l '<cudnn.h>'`; do
sed -i -e \
's@<cudnn.h>@"/home/hiroki11/env/local/cuda/include/cudnn.h"@g' \
"$file"
done
