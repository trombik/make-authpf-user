# - /etc/authpf/authpf.rules
# - /etc/authpf/authpf.conf
AUTHPF_USER?=	user
UNAME_PREFIX=	authpf_
MAX_DAYS?=	7
UNAME=	${UNAME_PREFIX}${AUTHPF_USER}
UHOME?=	/home/${UNAME}
RSA_SECRET_KEY?=	${UHOME}/.ssh/id_rsa
RSA_PUBLIC_KEY?=	${UHOME}/.ssh/id_rsa.pub
AUTHORIZED_KEY?=	${UHOME}/.ssh/authorized_keys

all:	adduser key

adduser:
	adduser \
		-class authpf -group authpf -shell authpf \
		-batch ${UNAME} authpf "${UNAME} (authpf)"

key:
	(sudo -u ${UNAME} /usr/bin/ssh-keygen -N "" -f ${RSA_SECRET_KEY})
	cp ${RSA_PUBLIC_KEY} ${AUTHORIZED_KEY}
	cat ${RSA_SECRET_KEY}

rmuser:
	rmuser ${UNAME}

# rmuser all users created MAX_DAYS ago
rmusers:
	for i in `find /home -mtime $$(( ${MAX_DAYS} + 1 )) -maxdepth 1 -name "${UNAME_PREFIX}*" | sed -e 's/^\/home\///'`; do \
		rmuser $$i; \
	done
