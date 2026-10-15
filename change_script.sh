#!/bin/bash
# Adds the `uint8_t isInstruction` parameter to update_replacement_state everywhere.
# Run from the repo root on a CLEAN checkout (git status clean). Safe to review with `git diff` afterwards.
set -e

# Refuse to run twice
if grep -q "(CACHE::\*update_replacement_state).*isInstruction" inc/cache.h; then
  echo "Already patched (inc/cache.h pointer already has isInstruction). Aborting."; exit 1
fi

# 1) Declarations in inc/cache.h: the shared function pointer + all per-level declarations
sed -i '/update_replacement_state)\?(uint32_t cpu/ s/uint8_t hit)/uint8_t hit, uint8_t isInstruction)/' inc/cache.h

# 2) Definitions in every LRU template + base_replacement.cc (rrip.l2c_repl already has it)
for f in replacement/lru.*_repl replacement/base_replacement.cc; do
  sed -i '/update_replacement_state(uint32_t cpu/ s/uint8_t hit)/uint8_t hit, uint8_t isInstruction)/' "$f"
done

# 3) Call sites in src/cache.cc (line numbers are from the unmodified repo)
sed -i -E '140s/, 0\);[[:space:]]*$/, 0, MSHR.entry[mshr_index].instruction);/'  src/cache.cc   # L2/L1 fill from MSHR
sed -i -E '527s/, 0\);[[:space:]]*$/, 0, MSHR.entry[mshr_index].instruction);/'  src/cache.cc   # fill from MSHR
sed -i -E '559s/, 0\);[[:space:]]*$/, 0, 0);/'  src/cache.cc                                       # DTLB_PB (not an instruction line)
sed -i -E '819s/, 1\);[[:space:]]*$/, 1, 0);/'  src/cache.cc                                       # writeback hit
sed -i -E '1080s/, 0\);[[:space:]]*$/, 0, 0);/' src/cache.cc                                       # writeback fill
sed -i -E '1543s/, 1\);[[:space:]]*$/, 1, 0);/' src/cache.cc                                       # DTLB_PB hit
sed -i -E '1766s/, 1\);[[:space:]]*$/, 1, RQ.entry[index].instruction);/' src/cache.cc            # read hit
sed -i -E '2452s/, 1\);[[:space:]]*$/, 1, PQ.entry[index].instruction);/' src/cache.cc            # prefetch hit

# 4) BTB calls in src/ooo_cpu.cc go through the same function-pointer type
sed -i -E '432s/, 0, 0, 1\);/, 0, 0, 1, 0);/'  src/ooo_cpu.cc
sed -i -E '456s/, 0, 0, 1\);/, 0, 0, 1, 0);/'  src/ooo_cpu.cc
sed -i -E '983s/, 0, 0\);[[:space:]]*$/, 0, 0, 0);/' src/ooo_cpu.cc

echo "Done."