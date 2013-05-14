clear all; close all; clear classes; clc;

%% Palik's SiO2 (Glass), p.753
wvlen1 = 1e-1 * [6.199 6.351 6.508 6.665 6.831 6.997 7.166 7.345 7.523 7.705];
n1 = [0.99993 0.99992 0.99992 0.99991 0.99991 0.99991 0.99990 0.99990 0.99989 0.99989];

k11 = 1e-5 * [1.503 1.636 1.781 1.936];
k12 = 1e-6 * [6.300 6.904 7.564 8.298 9.083 9.941];

k1 = [k11 k12];


%% Palik's SiO2 (Glass), p.754
wvlen2 = 1e-1 * [7.897 8.087 8.287 8.492 8.694 8.906 9.129 9.350 9.581 9.816 10.05 10.30 10.55 10.81 11.08 11.34 11.62 11.91 12.20 12.50 12.81 13.12 13.43 13.76 14.10 14.45 14.79 15.16 15.54 15.92 16.31 16.71 17.10 17.54 17.97 18.39 18.84 19.31 19.77 20.26 20.77 21.27 21.79 22.34 22.87 23.44 24.03];
n2 = [0.99988 0.99987 0.99987 0.99986 0.99985 0.99985 0.99984 0.99983 0.99982 0.99981 0.99981 0.99980 0.99979 0.99978 0.99976 0.99975 0.99974 0.99973 0.99971 0.99970 0.99968 0.99967 0.99965 0.99964 0.99962 0.99960 0.99958 0.99956 0.99954 0.99951 0.99949 0.99946 0.99944 0.99941 0.99938 0.99935 0.99932 0.99928 0.99925 0.99921 0.99917 0.99913 0.99909 0.99904 0.99899 0.99894 0.99889];

k21 = 1e-5 * [1.090 1.193 1.308 1.432 1.562 1.708 1.872 2.044 2.238 2.447 2.673 2.916 3.189 3.483 3.812 4.155 4.537 4.965 5.423 5.915 6.468 7.061 7.686 8.364 9.121 9.928];
k22 = 1e-4 * [1.080 1.179 1.289 1.407 1.535 1.671 1.813 1.981 2.149 2.326 2.536 2.771 3.009 3.270 3.560 3.862 4.199 4.578 4.971 1.486 1.621];
k2 = [k21 k22];


%% Palik's SiO2 (Glass), p.755
wvlen3 = 1e-1 * [24.60 25.20 25.83 26.43 27.07 27.74 28.44 29.10 29.87 30.54 31.31 32.12 32.89 33.69 34.53 35.32 36.25 37.12 38.03 38.99 39.86 40.92 41.88 42.90 43.96 45.08 46.09 47.32 48.43 49.59 50.81 52.09 53.44 54.62 56.10 57.40 58.76 60.18 61.68 63.25 64.91 66.30 68.12 69.65 71.25 72.93];
n3 = [0.99884 0.99878 0.99872 0.99866 0.99859 0.99852 0.99845 0.99837 0.99828 0.99821 0.99812 0.99802 0.99792 0.99782 0.99771 0.99760 0.99747 0.99735 0.99722 0.99708 0.99695 0.99678 0.99663 0.99646 0.99629 0.99609 0.99592 0.99570 0.99549 0.99527 0.99504 0.99478 0.99451 0.99427 0.99395 0.99367 0.99336 0.99304 0.99269 0.99231 0.99190 0.99155 0.99108 0.99068 0.99024 0.9898];

k31 = 1e-4 * [1.76 1.91 2.08 2.26 2.45 2.67 2.90 3.15 3.44 3.71 4.04 4.40 4.77 5.18 5.63 6.07 6.62 7.17 7.77 8.44 9.09 9.91];
k32 = 1e-3 * [1.07 1.16 1.25 1.36 1.46 1.59 1.71 1.85 2.00 2.16 2.34 2.50 2.72 2.92 3.14 3.37 3.63 3.90 4.21 4.47 4.82 5.11 5.44 5.80];

k3 = [k31 k32];


%% Palik's SiO2 (Glass), p.756
wvlen_n4 = [
    74.69	0.9893
    76.53	0.9887 
    78.47	0.9882 
    80.51	0.9875 
    82	0.9871 
    84	0.9865 
    86	0.986 
    88	0.9855 
    90	0.9853 
    92	0.9854 
    94	0.9858 
    96	0.9868 
    98	0.9872
    100	0.9874 
    102	0.9865 
    104	0.9851 
    106	0.9841 
    108	0.9848 
    110	0.9844 
    112	0.9822 
    114	0.9828 
    116	0.9867 
    118	0.9858 
    120	0.9839 
    122	0.9823 
    124	0.9813 
    126	0.9803 
    128	0.9794 
    130	0.9789 
    132	0.9778 
    134	0.977 
    136	0.9761 
    138	0.9747 
    150	0.9634 
    160	0.9608 
    170	0.9562 
    180	0.9509 
    190	0.9458 
    200	0.9416 
    210	0.9386 
    220	0.9328 
    230	0.9271 
    240	0.9222 
    250	0.9164 
    260 0.9105
    270 0.9207
    280 0.9175
    ];

wvlen4 = 1e-1 * wvlen_n4(:,1).';
n4 = wvlen_n4(:,2).';

k41 = 1e-3 * [6.19 6.62 6.99 7.30 7.3 7.6 8.1 8.9 9.9];
k42 = 1e-2 * [1.07 1.14 1.11 1.11];
k43 = 1e-3 * [9.7 8.5 8.3 9.6 9.9 9.0 9.3];
k44 = 1e-2 * [1.59 1.06];
k45 = 1e-3 * [7.5 6.5 6.8 7.0 7.3 7.6 7.6 8.3 8.7 9.3];
k46 = 1e-2 * [1.03 1.99 2.26 2.44 2.81 3.35 3.74 4.37 4.62 5.2 5.78 6.5 7.26 6.8 7.5];
k4 = [k41 k42 k43 k44 k45 k46];


%% Palik's SiO2 (Glass), p.757
wvlen_n5 = [
    290 0.9137
    300	0.913 
    310	0.907 
    320	0.901 
    330	0.895 
    340	0.888 
    350	0.882 
    360	0.877 
    370	0.870 
    380	0.866 
    390	0.858 
    400	0.851 
    410	0.845 
    420	0.839 
    430	0.833 
    440	0.827 
    450	0.822 
    460	0.817 
    470	0.813 
    480	0.808 
    490	0.804
    ];

wvlen5 = 1e-1 * wvlen_n5(:,1).';
n5 = wvlen_n5(:,2).';

k51 = 1e-2 * [8.2 9.0 9.2 9.4 9.8];
k52 = [0.107 0.113 0.120 0.128 0.137 0.144 0.156 0.169 0.180 0.190 0.202 0.218 0.233 0.250 0.270 0.282];
k5 = [k51 k52];

%% Palik's SiO2 (Glass), p.757, micron section
wvlen6 = 1e3 * [0.04959 0.0500 0.0510 0.05166 0.0520 0.0530 0.05391 0.0540 0.0550 0.0560 0.05636 0.0570 0.0580 0.0590 0.05904 0.0600 0.06199 0.06358 0.06526 0.06701 0.06888 0.06985];
n6 = [0.733 0.803 0.804 0.753 0.806 0.811 0.774 0.817 0.822 0.829 0.797 0.833 0.843 0.851 0.827 0.862 0.859 0.879 0.902 0.927 0.957 0.975];
k6 = [0.325 0.300 0.322 0.375 0.343 0.366 0.434 0.385 0.408 0.430 0.480 0.450 0.470 0.482 0.530 0.497 0.585 0.613 0.645 0.677 0.712 0.731];


%% Palik's SiO2 (Glass), p.758
wvlen7 = 1e3 * [0.07085 0.07187 0.07293 0.07402 0.07514 0.07630 0.07749 0.07872 0.07999 0.08130 0.08266 0.08405 0.08551 0.08700 0.08856 0.09017 0.09184 0.09357 0.09537 0.09724 0.09919 0.1012 0.1033 0.1051 0.1069 0.1088 0.1107 0.1127 0.1137 0.1148 0.1159 0.1170 0.1181 0.1187 0.1192 0.1198 0.1204 0.1210 0.1215 0.1228 0.1240 0.1252 0.1265 0.1278 0.1291 0.1305 0.1319];
n7 = [0.999 1.030 1.072 1.124 1.137 1.156 1.172 1.178 1.172 1.167 1.168 1.175 1.195 1.225 1.265 1.320 1.363 1.371 1.368 1.372 1.383 1.410 1.475 1.554 1.635 1.716 1.766 1.739 1.687 1.587 1.513 1.492 1.567 1.645 1.772 1.919 2.048 2.152 2.240 2.332 2.330 2.292 2.243 2.190 2.140 2.092 2.047];
k7 = [0.750 0.763 0.768 0.765 0.755 0.737 0.717 0.703 0.696 0.699 0.711 0.739 0.771 0.799 0.808 0.795 0.775 0.755 0.747 0.766 0.793 0.824 0.861 0.874 0.859 0.810 0.718 0.569 0.565 0.618 0.725 0.914 1.11 1.136 1.13 1.045 0.925 0.810 0.715 0.460 0.32 0.236 0.168 0.119 0.077 0.0561 0.0430];


%% Palik's SiO2 (Glass), p.759
wvlen8 = 1e3 * [0.1333 0.1348 0.1362 0.1378 0.1393 0.1409 0.1425 0.1442 0.1459 0.1476 0.1494 0.1512 0.1531 0.1550 0.1590 0.1631 0.1675 0.1722 0.1771 0.1837 0.1907 0.1984 0.2066 0.213856 0.214438 0.226747 0.230209 0.237833 0.239938 0.248272 0.265204 0.269885 0.275278 0.280347 0.289360 0.296728 0.302150 0.330259 0.334148 0.340365 0.346620 0.361051 0.365015 0.404656 0.435835 0.467816];
n8 = [2.006 1.969 1.935 1.904 1.876 1.850 1.825 1.803 1.783 1.764 1.747 1.730 1.716 1.702 1.676 1.653 1.633 1.616 1.600 1.582 1.567 1.554 1.543 1.53429 1.53371 1.52276 1.52009 1.51474 1.51338 1.50841 1.50004 1.49805 1.49592 1.49404 1.49099 1.48873 1.48719 1.48053 1.47976 1.47858 1.47746 1.47512 1.47453 1.46961 1.46669 1.46429];

k81 = [0.0339 0.0271 0.0228];
k82 = 1e-2 * [1.89 1.56 1.32 1.09];
k83 = 1e-3 * [8.38 5.57 3.17 1.40];
k84 = 1e-4 * [4.63 1.22];
k85 = [3.2e-5 4.7e-6];
k86 = zeros(1, length(n8)-length(k81)-length(k82)-length(k83)-length(k84)-length(k85));
k8 = [k81 k82 k83 k84 k85 k86];


%% Palik's SiO2 (Glass), p.760
wvlen9 = 1e3 * [0.486133 0.508582 0.546074 0.576959 0.579065 0.587561 0.589262 0.643847 0.656272 0.667815 0.706519 0.852111 0.894350 1.01398 1.08297 1.12866 1.3622 1.39506 1.4695 1.52952 1.6606 1.681 1.6932 1.70913 1.81307 1.97009 2.0581 2.1526 2.32542 2.4374 3.2439 3.2668 3.3026 3.422 3.5070 3.5564 3.7067 3.846 4.167];
n9 = [1.46313 1.46187 1.46008 1.45885 1.45877 1.45847 1.45841 1.45671 1.45637 1.45608 1.45515 1.45248 1.45185 1.45025 1.44941 1.44888 1.44621 1.44584 1.44497 1.44427 1.44267 1.44241 1.44226 1.44205 1.44069 1.43851 1.43722 1.43576 1.43292 1.43095 1.41314 1.41253 1.41155 1.40819 1.40568 1.40418 1.39936 1.395 1.383];
k9 = zeros(1, length(n9));


%% Palik's SiO2 (Glass), p.761
wvlen10 = 1e3 * [4.545 5.000 5.556 5.882 6.250 6.452 6.667 6.757 6.849 6.944 7.042 7.143 7.246 7.353 7.407 7.463 7.519 7.576 7.634 7.692 7.752 7.813 7.874 7.937 8.000 8.065 8.130 8.197 8.265];
n10 = [1.365 1.342 1.306 1.278 1.239 1.212 1.175 1.158 1.135 1.107 1.084 1.053 1.014 0.9702 0.9488 0.9175 0.8897 0.8600 0.8213 0.7719 0.7037 0.6232 0.5456 0.4677 0.4113 0.3931 0.4020 0.4329 0.4530];

k102 = 1e-2 * [3.72 4.74 7.68];
k103 = [0.132 0.216 0.323 0.446 0.553 0.635 0.704];
k101 = zeros(1, length(n10)-length(k102)-length(k103));
k10 = [k101 k102 k103];


%% Palik's SiO2 (Glass), p.762
wvlen11 = 1e3 * [8.333 8.403 8.475 8.547 8.621 8.696 8.772 8.850 8.929 9.009 9.091 9.174 9.302 9.524 9.756 10.00 10.26 10.53 10.81 11.11 11.36 11.63 11.76 11.90 12.05 12.20 12.35 12.50 12.66 12.82 12.99 13.16 13.33 13.79 14.29 14.81 15.38 16.00 16.67 17.24 17.86 18.52 18.97 19.23 19.61 20.00];
n11 = [0.4600 0.4730 0.4746 0.4656 0.4563 0.4309 0.3915 0.3563 0.3705 0.5846 1.043 1.616 2.250 2.760 2.839 2.694 2.448 2.224 2.038 1.869 1.784 1.690 1.652 1.619 1.615 1.658 1.701 1.753 1.789 1.811 1.810 1.779 1.756 1.698 1.643 1.598 1.555 1.502 1.450 1.401 1.337 1.235 1.161 1.050 0.8857 0.6616];

k111 = [0.771 0.840 0.903 0.978 1.07 1.17 1.32 1.53 1.85 2.27 2.55 2.63 2.26 1.65 0.962 0.509 0.231 0.102];
k112 = 1e-2 * [4.60 5.06 7.75];
k113 = [0.116 0.152 0.204 0.267 0.323 0.341 0.343 0.314 0.275 0.227 0.192 0.177 0.157 0.157 0.168 0.182 0.202 0.235 0.264 0.298 0.341 0.377 0.415 0.524 0.822];
k11 = [k111 k112 k113];


%% Palik's SiO2 (Glass), p.763
wvlen12 = 1e3 * [20.41 20.83 21.05 21.28 21.74 22.73 23.81 25.00 26.67 28.57 30.77 33.33 36.36 40.00 100.0 125.0 166.7 250.0 500.0];
n12 = [0.5777 0.7517 1.002 1.484 2.308 2.936 2.912 2.739 2.537 2.388 2.284 2.210 2.147 2.100 1.967 1.962 1.959 1.957 1.955];

k121 = [1.28 1.86 2.22 2.39 2.29 1.29 0.738 0.397 0.199 0.13];
k122 = 1e-2 * [9.2 6.7 5.6 4.6 1.59 1.19];
k123 = 1e-3 * [8.62 6.96 7.96];
k12 = [k121 k122 k123];


%% Collect all.
wvlen = [wvlen1 wvlen2 wvlen3 wvlen4 wvlen5 wvlen6 wvlen7 wvlen8 wvlen9 wvlen10 wvlen11 wvlen12].';
n = [n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12].';
k = [k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 k11 k12].';

%% Convert the wavelengths to the photon energies.
eV = PhysC.h * PhysC.c0 * 1e9 ./ wvlen;

%% Reverse the data order.
eV = eV(end:-1:1);
n = n(end:-1:1);
k = k(end:-1:1);
wvlen = wvlen(end:-1:1);

%% Calculate the permittivity from n and k following the exp(+i w t) time dependence.
eps = (n - 1i*k).^2;

%% Plot n and k.  Compare with Fig.10 on p.753 of Palik.
nk_wvlen = 1;
eps_eV = 2;
eps_wvlen = 3;
plotstyle = nk_wvlen;
switch plotstyle
    case nk_wvlen  % plot n and k
        loglog(wvlen, n, 'o-', wvlen, k, 'o-')
        %plot(wvlen, n, wvlen, k)
        legend('n', 'k', 'Location', 'SouthEast');
        xlabel 'wavelength (nm)'
        %axis([1e2 1e4 1e-2 1e2])
    case eps_eV  % plot real(eps) and -imag(eps)
        plot(eV, real(eps), 'o-', eV, -imag(eps), 'o-')
        legend('\epsilon_1', '\epsilon_2', 'Location', 'SouthEast');
        xlabel 'Photon Energy (eV)'
        %axis([0.5 6.5 -7 7]);
    case eps_wvlen
        plot(wvlen, real(eps), 'o-', wvlen, -imag(eps), 'o-')
        legend('\epsilon_1', '\epsilon_2', 'Location', 'SouthEast');
        xlabel 'wavelength (nm)'
        %axis([0 1e2 -1e1 1e1])
end


%% Save data.
save(mfilename, 'eV', 'n', 'k');
