matlab -nodisplay -nodesktop -r "compute_features_mnist('../framenet/MNIST_dataset/train-images.idx3-ubyte', '../framenet/MNIST_dataset/train-labels.idx1-ubyte', '../framenet/MNIST_dataset/t10k-images.idx3-ubyte', '../framenet/MNIST_dataset/t10k-labels.idx1-ubyte', 'mnisttrain.mat', 'mnisttest.mat', '../framenet/'); exit()"
matlab -nodisplay -nodesktop -r "compute_features_mnist('../framenet/MNIST_dataset/train-images.idx3-ubyte', '../framenet/MNIST_dataset/train-labels.idx1-ubyte', '../framenet/MNIST_dataset/t10k-images.idx3-ubyte', '../framenet/MNIST_dataset/t10k-labels.idx1-ubyte', 'mnistdisptrain.mat', 'mnistdisptest.mat', '../framenet/',4); exit()"
python -c "import forest_mnist; forest_mnist.run('mnisttrain.mat', 'mnisttest.mat', 'rfmnist.pkl', 14)"
python -c "import forest_mnist; forest_mnist.run('mnistdisptrain.mat', 'mnistdisptest.mat', 'rfmnistdisp.pkl', 16)"
python feat_imp_mnist.py