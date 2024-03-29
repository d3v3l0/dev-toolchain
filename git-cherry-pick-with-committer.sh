#!/bin/bash
#
# Copyright (c) 2013-2014 David Ingram
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

LOG_CMD="git log -1 --pretty=format:"
ARGS=''
COMMIT=''

# iterate over args
for i; do
	if [[ "$i" = -* ]]; then
		ARGS="$ARGS $i"
	elif [[ "$i" =~ '^[0-9]+$' ]] && [[ "$ARGS" =~ '-m\s*$' ]]; then
		ARGS="$ARGS $i"
	elif [[ -n "$COMMIT" ]]; then
		echo "Multiple commits specified? Weird."
		exit 1
	else
		COMMIT=$i
	fi
done

export GIT_AUTHOR_NAME="$(${LOG_CMD}%an $COMMIT)"
export GIT_AUTHOR_EMAIL="$(${LOG_CMD}%ae $COMMIT)"
export GIT_AUTHOR_DATE="$(${LOG_CMD}%ad $COMMIT)"
export GIT_COMMITTER_NAME="$(${LOG_CMD}%cn $COMMIT)"
export GIT_COMMITTER_EMAIL="$(${LOG_CMD}%ce $COMMIT)"
export GIT_COMMITTER_DATE="$(${LOG_CMD}%cd $COMMIT)"
export GIT_EDITOR="grep -vE '^#'"

echo "Author:     ${GIT_AUTHOR_NAME} <${GIT_AUTHOR_EMAIL}>"
echo "AuthorDate: ${GIT_AUTHOR_DATE}"
echo "Commit:     ${GIT_COMMITTER_NAME} <${GIT_COMMITTER_EMAIL}>"
echo "CommitDate: ${GIT_COMMITTER_DATE}"
echo
git cherry-pick --no-commit $ARGS $COMMIT
git commit
