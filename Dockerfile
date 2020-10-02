FROM pranaysashank/ghc:8.10.2-1.2

ARG GHC=8.10.2
ARG HLS=0.4.0
ENV HOME=/home/theia

# Set user and group
ARG user=theia
ARG group=theia
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} && \
    mkdir /projects && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd" "/projects"; do \
      echo "Changing permissions on ${f}" && chgrp -R ${group} ${f} && \
      chmod -R g+rwX ${f}; \
    done

USER ${uid}:${gid}

RUN cd $HOME && mkdir -p ${HOME}/.local/bin && \
    wget https://github.com/haskell/haskell-language-server/releases/download/${HLS}/haskell-language-server-wrapper-Linux.gz && \
    gzip -d haskell-language-server-wrapper-Linux.gz && \
    chmod +x haskell-language-server-wrapper-Linux && \
    mv haskell-language-server-wrapper-Linux ${HOME}/.local/bin/haskell-language-server-wrapper-${HLS}-linux && \
    wget https://github.com/haskell/haskell-language-server/releases/download/${HLS}/haskell-language-server-Linux-${GHC}.gz && \
    gzip -d haskell-language-server-Linux-${GHC}.gz && \
    chmod +x haskell-language-server-Linux-${GHC} && \
    mv haskell-language-server-Linux-${GHC} ${HOME}/.local/bin/haskell-language-server-${HLS}-linux-${GHC} && \
    cabal update

ADD etc/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ${PLUGIN_REMOTE_ENDPOINT_EXECUTABLE}
