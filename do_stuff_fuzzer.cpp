// Copyright 2017 Google Inc. All Rights Reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
#include "my_api.h"

#include <string>
#include <stdlib.h>

// Simple fuzz target for DoStuff().
// See http://libfuzzer.info for details.
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  if (size < 4) {
    return 0;
  }
  std::string str(reinterpret_cast<const char *>(data), size);
  DoStuff(str);  // Disregard the output.
  vuln(data[0]);
  return 0;
}
