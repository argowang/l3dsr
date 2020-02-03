#
# Include file of common macros for makefiles.
#

define nl


endef

define pound
#
endef

comma := ,
empty :=
space := $(empty) $(empty)


PWD       := $(shell pwd)

rpmdirs    = BUILD RPMS SOURCES SPECS SRPMS


# Ensure the macro named is set to a non-empty value.
varchk_call = $(if $($(1)),,$(error $(1) is not set from calling environment))

# Ensure all the macros named in the list are set to a non-empty value.
varchklist_call = $(foreach v,$(1),$(call varchk_call,$v))

# Quote the argument with double quotes escaping shell metacharacters.
shdq_call = "$(subst ",\",$(subst `,\`,$(subst $$,\$$,$(subst \,\\,$(1)))))"

# For each macro named in the $(2) list, prepare it to be passed via
# the shell to another command after expanding the name with the suffix
# passed in $(1).  For example, $(call mkargs2_call,_rhel4,VAR) expands
# to VAR="$(VAR_rhel4)" with the string properly escaped.
mkargs2_call = $(foreach v,$(2),$v=$(call shdq_call,$($v$(1))))

# For each macro named in the $(1) list, prepare it to be passed via
# the shell to another command.  For example, $(call mkargs_call,VAR)
# expands to VAR="$(VAR)" with the string properly escaped.
mkargs_call = $(call mkargs2_call,,$(1))

copy_file_cmd_call = \
	[ -d '$(dir $(2))' ] || mkdir -p -- '$(dir $(2))' && \
	cp -a -- '$(1)' '$(2)'$(nl)

scrub_files_cmd_call = $(foreach f,$(wildcard $(1)),rm -rf -- '$f'$(nl))

mkdirs_cmd_call = $(foreach f,$(filter-out $(wildcard $(1)),$(1)),\
		    mkdir -p -- '$f'$(nl))

mkrpmdirs_cmd_call = $(call mkdirs_cmd_call,$(addprefix $(1)/,$(rpmdirs)))
