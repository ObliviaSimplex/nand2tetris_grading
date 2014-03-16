#!/bin/bash

{ grep -R --include=And.hdl "And(\|Or(\|Not(\|Xor(" working/; \
grep -R --include=Or.hdl "And(\|Or(\|Not(\|Xor(" working/; \
grep -R --include=Not.hdl "And(\|Or(\|Not(\|Xor(" working/; \
grep -R --include=Xor.hdl "And(\|Or(\|Not(\|Xor(" working/; } \
| LANG=C sort
