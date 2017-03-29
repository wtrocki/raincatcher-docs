# Establish global variables to the docs and script dirs
CURRENT_DIR="$( pwd -P)"
SCRIPT_SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
DOCS_SRC="${SCRIPT_SRC%/*/*}/docs"

# Do not produce pot/po by default
L10N=
# A comma separated lists of default locales that books should be translated to.
# This can be overriden in each book's individual buildGuides.sh
LANG_CODE=ja-JP

usage(){
  cat <<EOM
USAGE: $0 [OPTION]... <guide>

DESCRIPTION: Build all of the books (default) or a single book.

Run this script from either the root of your cloned repository or from the 'scripts' directory.  Example:
  cd MY_DOCUMENTATION_REPOSITORY/resources/scripts
  $0

OPTIONS:
  -h       Print help.

EXAMPLES:
  Build all guides:
   $0

  Build a specific guide(s) from $DOCS_SRC:
    $0 my-title-a
    $0 my-title-b
    $0 my-title-c
EOM
# Now list the valid book values
listvalidbooks
}

listvalidbooks(){
  echo ""
  echo "  Valid book argument values are:"
  cd $DOCS_SRC
  subdirs=`find . -maxdepth 1 -type d ! -iname ".*" ! -iname "topics" | sort`
  for subdir in $subdirs
  do
    echo "   ${subdir##*/}"
  done
  echo ""
  # Return to where we started as a courtesy.
  cd $CURRENT_DIR
}


OPTIND=1
while getopts "h" c
 do
     case "$c" in
       h)         usage
                  exit 1;;
       \?)        echo "Unknown option: -$OPTARG." >&2
                  usage
                  exit 1;;
     esac
 done
shift $(($OPTIND - 1))

# Use $DOCS_SRC so we don't have to worry about relative paths.
cd $DOCS_SRC

# Set the list of docs to build to whatever the user passed in (if anyting)
subdirs=$@
if [ $# -gt 0 ]; then
  echo "=== Bulding only $@ ==="
else
  echo "=== Building all the books ==="
  # Recurse through the book directories and build them.

  # The following is the original command that worked with the EAP structure:
   # subdirs=`find . -maxdepth 1 -type d ! -iname ".*" ! -iname "topics" | sort`

   # This should work for the multi-topic-level structure but has not been tested:
  subdirs=`find . -maxdepth 1 -type d ! -iname ".*" ! -iname "topics" ! -iname "shared" | sort`
fi

for subdir in $subdirs
do
  echo ""
  echo "Building $DOCS_SRC/${subdir##*/}"
  # Navigate to the dirctory and build it
  if ! [ -e $DOCS_SRC/${subdir##*/} ]; then
    BUILD_MESSAGE="$BUILD_MESSAGE\nERROR: $DOCS_SRC/${subdir##*/} does not exist."
    # This is a book argument error so we should list the valid arguments.
    LIST_BOOKS="true"
    continue
  fi
  cd $DOCS_SRC/${subdir##*/}
  GUIDE_NAME=${PWD##*/}
  ./buildGuides.sh $L10N
  if [ "$?" = "1" ]; then
    BUILD_ERROR="ERROR: Build of $GUIDE_NAME failed. See the log above for details."
    BUILD_MESSAGE="$BUILD_MESSAGE\n$BUILD_ERROR"
  fi
  # Return to the parent directory
  cd $SCRIPT_SRC
done

# Return to where we started as a courtesy.
cd $CURRENT_DIR

# Report any errors
echo ""
if [ "$BUILD_MESSAGE" == "$BUILD_RESULTS" ]; then
  echo "Build was successful!"
else
  echo -e "${RED}$BUILD_MESSAGE${NO_COLOR}"
  if [ "$LIST_BOOKS" ]; then
    listvalidbooks
  else
    # This is a build error.
    echo -e "${RED}Please fix all issues before requesting a merge!${NO_COLOR}"
  fi
fi

exit;
