# ChampSim

ChampSim is a trace-based simulator for microarchitecture research.

Useful trace links:
- Traces (access requires an LDAP ID): https://drive.google.com/drive/folders/1zYchkn-M1auZp_l5wRkIzAcDYPkNtW3H?usp=sharing
- ChampSim wiki: https://champsim.github.io/ChampSim/master/index.html

## Clone the repository

```bash
git clone https://github.com/cs683-iitb-autumn-2026/pa2.git
```

## Compile

To compile ChampSim, specify three parameters: the L1D prefetcher, the L2C replacement policy, and the binary name.

For example, `./build_champsim.sh no lru baseline` builds a single-core processor with a hashed perceptron branch predictor, no L1D data prefetcher, and the LRU replacement policy for the L2C.

You can give the binary any name. Custom names help distinguish binaries that use the same configuration.

```bash
./build_champsim.sh ${L1D_PREFETCHER} ${L2C_REPLACEMENT} ${BINARY_NAME}

./build_champsim.sh no lru baseline
```

## Run simulation

```bash
./bin/[BINARY] -warmup_instructions [N_WARM] -simulation_instructions [N_SIM] -traces [TRACE_DIR]/[TRACE]
./bin/hashed_perceptron-no-no-no-no-no-no-no-lru-lru-lru-lru-lru-lru-lru-lru-1core-baseline -warmup_instructions 25000000 -simulation_instructions 25000000 -traces ../traces/trace1.champsimtrace.xz
```

Where:
- `${BINARY}`: ChampSim binary compiled by `build_champsim.sh` (for example, `hashed_perceptron-no-no-no-no-no-no-no-lru-lru-lru-lru-lru-lru-lru-lru-1core-baseline`)
- `${N_WARM}`: number of instructions for the warmup period (25 million)
- `${N_SIM}`: number of instructions for the detailed simulation (25 million)
- `${TRACE_DIR}`: directory containing the trace (for example, `../traces/`)
- `${TRACE}`: name of the trace (for example, `trace1.champsimtrace.xz`)

## Evaluate the simulation

ChampSim measures IPC (instructions per cycle) as its main performance metric. It also prints other useful metrics at the end of each simulation.

## Install GCC 7 on Ubuntu

```bash
sudo apt update
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
vim /etc/apt/sources.list
```

Update the last line with:

```bash
deb [arch=amd64] http://archive.ubuntu.com/ubuntu focal main universe
```

Then run:

```bash
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get install gcc-7
sudo apt-get install g++-7
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 0
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 0
```

If GCC and G++ are already present in `/usr/bin`, configure the alternatives using:

```bash
sudo update-alternatives --config g++
sudo update-alternatives --config gcc
```


## PA2 Results

Speedup is relative to the no-prefetch LRU baseline of the same trace.
SPP results use `prefetcher/spp_v2.l1d_pref`, e.g. `./build_champsim.sh spp_v2 dyn_irrip_spp spp_dyn` for Task 3.

### Task 1B: SPP at L1D (L2C = LRU)

| Trace | Config | IPC | Speedup | L1D Load MPKI | PF Accuracy | PF Coverage |
|---|---|---|---|---|---|---|
| 1 | No prefetch | 0.2321 | 1.0000 | 10.6781 | - | - |
| 1 | SPP | 0.2337 | 1.0068 | 9.7240 | 51.67% | 8.94% |
| 2 | No prefetch | 0.2508 | 1.0000 | 13.5356 | - | - |
| 2 | SPP | 0.2512 | 1.0014 | 13.3224 | 42.02% | 1.58% |
| 3 | No prefetch | 0.3822 | 1.0000 | 3.4033 | - | - |
| 3 | SPP | 0.3847 | 1.0065 | 3.1529 | 31.32% | 7.36% |

### Task 2A: I-RRIP at L2C (no prefetch)

| Trace | Config | IPC | Speedup | L2C Load MPKI | L2 Instr MPKI | L2 Data MPKI |
|---|---|---|---|---|---|---|
| 1 | LRU | 0.2321 | 1.0000 | 17.7528 | 10.4106 | 7.3422 |
| 1 | RRIP | 0.2320 | 0.9996 | 17.6424 | 10.5698 | 7.0726 |
| 1 | I-RRIP | 0.2322 | 1.0007 | 17.4518 | 10.0897 | 7.3621 |
| 2 | LRU | 0.2508 | 1.0000 | 28.1187 | 19.5200 | 8.5986 |
| 2 | RRIP | 0.2515 | 1.0028 | 26.4582 | 18.4474 | 8.0108 |
| 2 | I-RRIP | 0.2562 | 1.0214 | 22.6667 | 13.8182 | 8.8485 |
| 3 | LRU | 0.3822 | 1.0000 | 3.9533 | 1.1230 | 2.8302 |
| 3 | RRIP | 0.3819 | 0.9993 | 4.0346 | 1.1949 | 2.8397 |
| 3 | I-RRIP | 0.3820 | 0.9996 | 3.9302 | 1.0764 | 2.8538 |

### Task 2B: Dynamic I-RRIP threshold sensitivity (no prefetch)

| Trace | Config | IPC | Speedup | L2C Load MPKI | L2 Instr MPKI | L2 Data MPKI |
|---|---|---|---|---|---|---|
| 1 | thr 0.10 | 0.2322 | 1.0006 | 17.4688 | 10.1195 | 7.3492 |
| 1 | thr 0.25 | 0.2323 | 1.0008 | 17.4418 | 10.0909 | 7.3509 |
| 1 | thr 0.38 | 0.2322 | 1.0007 | 17.4309 | 10.1459 | 7.2850 |
| 1 | thr 0.43 | 0.2321 | 1.0002 | 17.5254 | 10.3174 | 7.2080 |
| 1 | thr 0.60 | 0.2320 | 0.9996 | 17.6311 | 10.5674 | 7.0637 |
| 2 | thr 0.10 | 0.2559 | 1.0202 | 22.9327 | 14.1152 | 8.8174 |
| 2 | thr 0.25 | 0.2559 | 1.0202 | 22.9327 | 14.1152 | 8.8174 |
| 2 | thr 0.38 | 0.2553 | 1.0179 | 23.3624 | 14.5962 | 8.7662 |
| 2 | thr 0.43 | 0.2553 | 1.0179 | 23.3624 | 14.5962 | 8.7662 |
| 2 | thr 0.60 | 0.2546 | 1.0150 | 23.9202 | 15.3346 | 8.5855 |
| 3 | thr 0.10 | 0.3819 | 0.9994 | 3.9581 | 1.1034 | 2.8547 |
| 3 | thr 0.25 | 0.3819 | 0.9992 | 3.9827 | 1.1261 | 2.8566 |
| 3 | thr 0.38 | 0.3819 | 0.9993 | 3.9813 | 1.1253 | 2.8560 |
| 3 | thr 0.43 | 0.3819 | 0.9993 | 3.9840 | 1.1287 | 2.8554 |
| 3 | thr 0.60 | 0.3819 | 0.9993 | 4.0364 | 1.1954 | 2.8410 |

### Task 3: SPP + Dynamic I-RRIP

| Trace | Config | IPC | Speedup | PF Accuracy | PF Coverage | L1D Load MPKI | L2C Load MPKI | L2 Instr MPKI | L2 Data MPKI |
|---|---|---|---|---|---|---|---|---|---|
| 1 | No prefetch + LRU | 0.2321 | 1.0000 | - | - | 10.6781 | 17.7528 | 10.4106 | 7.3422 |
| 1 | Dyn I-RRIP | 0.2323 | 1.0008 | - | - | 10.6784 | 17.4418 | 10.0909 | 7.3509 |
| 1 | SPP + LRU | 0.2337 | 1.0068 | 51.67% | 8.94% | 9.7240 | 16.9648 | 10.4396 | 6.5253 |
| 1 | SPP + Dyn I-RRIP | 0.2340 | 1.0082 | 51.24% | 8.90% | 9.7272 | 16.6042 | 10.0684 | 6.5358 |
| 2 | No prefetch + LRU | 0.2508 | 1.0000 | - | - | 13.5356 | 28.1187 | 19.5200 | 8.5986 |
| 2 | Dyn I-RRIP | 0.2559 | 1.0202 | - | - | 13.5408 | 22.9327 | 14.1152 | 8.8174 |
| 2 | SPP + LRU | 0.2512 | 1.0014 | 42.02% | 1.58% | 13.3224 | 28.2084 | 19.7393 | 8.4691 |
| 2 | SPP + Dyn I-RRIP | 0.2566 | 1.0231 | 42.83% | 1.60% | 13.3196 | 22.7044 | 14.0842 | 8.6202 |
| 3 | No prefetch + LRU | 0.3822 | 1.0000 | - | - | 3.4033 | 3.9533 | 1.1230 | 2.8302 |
| 3 | Dyn I-RRIP | 0.3819 | 0.9992 | - | - | 3.4032 | 3.9827 | 1.1261 | 2.8566 |
| 3 | SPP + LRU | 0.3847 | 1.0065 | 31.32% | 7.36% | 3.1529 | 3.5429 | 1.1372 | 2.4058 |
| 3 | SPP + Dyn I-RRIP | 0.3846 | 1.0064 | 32.47% | 7.77% | 3.1387 | 3.5278 | 1.1205 | 2.4073 |


Plots for each task are in `Plots/Task1`, `Plots/Task2` and `Plots/Task3`.
