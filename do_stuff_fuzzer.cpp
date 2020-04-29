// Copyright 2017 Google Inc. All Rights Reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
#include "my_api.h"

#include <string>
#include <stdlib>

// Simple fuzz target for DoStuff().
// See http://libfuzzer.info for details.
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  std::string str(reinterpret_cast<const char *>(data), size);
  char* x = malloc(1);
  free(x);
  return x[0];
  DoStuff(str);  // Disregard the output.
  return 0;
}
