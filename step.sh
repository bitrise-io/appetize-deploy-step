#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Download the binary
wget "https://github.com/dag-io/appetize-deploy/releases/download/0.1.4/appetize-deploy.phar" -P $THIS_SCRIPTDIR

source "${THIS_SCRIPTDIR}/_bash_utils/utils.sh"
source "${THIS_SCRIPTDIR}/_bash_utils/formatted_output.sh"

# init / cleanup the formatted output
echo "" > "${formatted_output_file_path}"

if [ -z "${app_path}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$app_path` not provided!'
	exit 1
fi

if [ -z "${platform}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$platform` not provided!'
	exit 1
fi

if [ -z "${appetize_token}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$appetize_token` not provided!'
	exit 1
fi

resp=$(php "${THIS_SCRIPTDIR}/appetize-deploy.phar")
ex_code=$?

if [ ${ex_code} -eq 0 ] ; then
	echo "${resp}"
	write_section_to_formatted_output "# Success"
	echo_string_to_formatted_output "Build successfully deployed."
	exit 0
fi

write_section_to_formatted_output "# Error"
write_section_to_formatted_output "Deploying the build failed with the following error:"
echo_string_to_formatted_output "${resp}"
exit 1
