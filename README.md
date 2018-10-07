# shearlet-scattering
Scattering transforms with shearlet-based filters using the framework of Wiatowski et al.  (called "framenet").


## Overview
This software is a minor modification of the framenet codes made publicly available by T. Wiatowski et al.  The shearlet-based filter configuration did not run out-of-the-box for on my local machine (in part due to my not having the parallel computing toolbox available; note also shearlets were a feature that, while in the code, was not included in their publication so it may have been a work in progress).  

I have also taken the liberty of downloading the software dependencies for framenet and adding them to this repository.  These include Shearlab 3D, MNIST data loading utilities, and a custom implemention of ols dimension reduction.  See the framenet documentation for more details.  I have retained the copyright statements where provided and provided links to the original sources (sometimes implicitly via shell scripts that can be used to download their codes).

## Quick start

1.  *Obtain MNIST*.  This code is designed exclusively (?) for experiments involving MNIST. You will also need the MNIST data set.  There are two scripts I have added in  the [mnist data directory](./src/framenet/MNIST_dataset) which will (a) download MNIST and (b) rename the files to match what the framenet codes expect.  

2.  *Generate shearlet scattering features*.  I (mjp) have created a script [shearlet_single_run_mjp](./src/framenet/shearlet_single_run_mjp.m) that will generate scattering features for a subset of MNIST.  In particular, we generate features only for the subset of the training data set needed for our experiments.  We also to the extent possible use only default parameters from framenet and do not (as of this writing) conduct hyperparameter selection.

3.  *Evaluate performance*.  While framenet can run SVM evaluation, for comparison across wavelet scatterings I created a simple standalone script for evaluating using linear SVMs (which is also used for Morlet and CHCDW wavelets in a separate project).  A copy of the evaluation script is available [here](./src/evaluation/classify_main.m).  Note this requires a local libsvm installation.  With some minor modifications the script could be changed to use Matlab's built-in SVM, if desired.

## Expected results

The results reported below are for the default framenet shearlet configuration ("shearlet0"), a two-layer scattering network configuration similar to that provided by the framenet authors for MNIST with separable wavelets (although I omit dimension reduction and make a few other changes), and and linear SVM.  Note that I do not embark upon hyperparameter search (in part, do to limited time and computational resources) so the results below could possibly be improved upon.  Values reported in the table are *error rates*, aggregated across all 10 classes on the MNIST test set (which has 10000 instances).
Another caveat is that we use MNIST images that are of size 31x31 (framenet default).  These may be on the small side for optimal processing with Shearlab.

I have also included some results from our experiments with Haar-type CDW using the "Complete Product" (CP) (joint work with W. Czaja).


| MNIST # Train | FrameNet-m1 | FrameNet-m2 | CP-H12-m1  | CP-H12-m1-DR   | ScatNet-6-m1 | ScatNet-6-m2 | CP-M6-m1 |
|      :---:    |   :---:     |    :---:    |   :---:    | :---:          |  :---:       |  :---:       | :---:    |
|    300        |   21.2      |   13.20     |    11.93   | 11.61          |  7.69        | 8.67         | 9.34     |
|    500        |   13.63     |  7.59       |   6.59     | 6.73           |  5.85        | 3.79         | 4.76     |
|    700        |   10.97     |   5.99      |    5.55    |  5.73          |  5.03        | 3.23         | 4.12     |
|    1000       |   10.12     |  5.12       |     4.91   |   4.9          |  4.42        | 2.70         | 3.35     |
|    2000       |   8.27      |  4.07       |     3.59   |   3.6          |  3.08        | 2.03         | 2.45     |
|    5000       |   6.28      |  2.84       |     2.52   |   2.57         |  2.11        | 1.41         | 1.71     |

Some information about these feature sets:

|                     | FrameNet-m1 | FrameNet-m2 |  CP-12-m1    | CP-12-m1-DR    | ScatNet-6-m1 | ScatNet-6-m2 | CP-M6-m1 |
|  :---:              | :---:       |     :---:   |  :---:       |  :---:         |  :---:       | :---:        | :---:    |
| Framework           | FrameNet    | FrameNet    |  CP          |  CP            |  ScatNet     | ScatNet      |  CP      |
| SVM                 | linear      | linear      |  linear      | linear         |  linear      | linear       | linear   |
| Scattering order    | 1           |   2         |   1          | 1              |  1           | 2            |  1       |
| wavelet             | Shearlet    | Shearlet    |  CHCDW-12    | CHCDW-12       |  Morlet      | Morlet       |  Morlet  |
| Spatial Dims        |             |             |  8x8         |  8x8           |              | 8x8          |  8x8     |
| Wavelet Scales      |             |             |   5          |  5             |   4          |  4           |  4       |
| "Directions"        |             |             |   12         |  12            |   6          |  6           |  6       |
| dim. reduction      | none        | none        |  none        | SVM-weight     | none         | none         | none     |
|  # dimensions       | 1089        | 9801        |  12288       |  9801          |  400         | 3856         |  1600    |

The CHCDW-12 dimension size comes from downsampling a 32x32 image by a factor of 4, L=3, and J=log(32):
1. layer 1: 8 * 8 * 12 = 768
2. layer 2: (8*8*12) * (3*log(32)) = 11520

Notes:
1. FrameNet provides state-of-the art performance (comparable with ScatNet+Morlet-6) for MNIST when using separable wavelets and a full training data set (see their paper).  So we believe the FrameNet architecture & theory is sound; our experiments here are explicitly to explore properties of Shearlet scatterings not to say anything about FrameNet as a whole vs. another scattering architecture.
2.  Similarly, our goal is not to try to get best possible overall performance on MNIST, but to as fairly as possible compare different CDW wavelets in scattering context.  Hence the linear svm and minimal dimension reduction.  Otherwise, interpretation becomes even more difficult than it already is.  We refer reader to FrameNet and ScatNet papers for what is possible when all measures are taken to get best possible results.

## References

1.  [Framenet Download Link](https://www.nari.ee.ethz.ch/commth/research/downloads/dl_feat_extract.html) (last accessed: Sept. 2018)
2.  Wiatowski et al. [Discrete deep feature extraction: A theory and new architectures](https://www.nari.ee.ethz.ch/commth/pubs/p/ICML2016), 2016.
3.  Bruna & Mallat [Invariant Scattering Convolution Networks](https://www.di.ens.fr/~mallat/papiers/Bruna-Mallat-Pami-Scat.pdf), 2013.
