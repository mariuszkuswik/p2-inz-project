#!/bin/bash

# Build iso image with meta files
genisoimage -o Meta/meta.iso -J -r -C Meta/ 
