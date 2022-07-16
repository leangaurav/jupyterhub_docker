FROM jupyterhub/jupyterhub:1.4.2

WORKDIR jupyter
COPY config/jupyterhub_config.py /srv/

RUN python3 -m pip install --upgrade pip
RUN pip install oauthenticator
RUN pip install jupyter

ENTRYPOINT jupyterhub --log-level=DEBUG -f /srv/jupyterhub_config.py
