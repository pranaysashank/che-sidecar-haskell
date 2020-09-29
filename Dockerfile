FROM pranaysashank/ghc:8.10.2-1.2

ARG GHC=8.10.2
ARG HLS=0.4.0
ENV HOME=/home/theia

RUN mkdir /projects ${HOME} && \
    # Change permissions to let any arbitrary user
    for f in "${HOME}" "/etc/passwd" "/projects"; do \
      echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
      chmod -R g+rwX ${f}; \
    done && \
    wget https://github.com/haskell/haskell-language-server/releases/download/${HLS}/haskell-language-server-wrapper-Linux.gz && \
    gzip -d haskell-language-server-wrapper-Linux.gz && \
    chmod +x haskell-language-server-wrapper-Linux && \
    mv haskell-language-server-wrapper-Linux /usr/local/bin/ && \
    wget https://github.com/haskell/haskell-language-server/releases/download/${HLS}/haskell-language-server-Linux-${GHC}.gz && \
    gzip -d haskell-language-server-Linux-${GHC}.gz && \
    chmod +x haskell-language-server-Linux-${GHC} && \
    mv haskell-language-server-Linux-${GHC} /usr/local/bin/ && \
    cabal update

ADD etc/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ${PLUGIN_REMOTE_ENDPOINT_EXECUTABLE}
