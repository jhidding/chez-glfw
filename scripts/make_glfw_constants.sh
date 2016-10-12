SEARCH='^#define GLFW_[_A-Z0-9]*'

GETNAME='s/^#define \(GLFW_[_A-Z0-9]*\).*$/\1/'

REPLAC0='s/#define /   (define /; s/  */ /g; s/\/\*.*\*\///;'
#        ^define syntax        ^rm space  ^rm comments    
REPLAC1='s/ 0x/ #x/; s/ *$//; s/$/)/'
#        ^hex-syntax ^strip   ^close S-expr

echo    "(library (glfw constants)"
echo    "  (export"

grep -E "${SEARCH}" /usr/include/GLFW/glfw3.h \
    | sed -e "${GETNAME}"
echo    ")"

grep -E "${SEARCH}" /usr/include/GLFW/glfw3.h \
    | sed -e "${REPLAC0} ${REPLAC1}"
echo    ")"

