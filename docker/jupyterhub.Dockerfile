FROM jupyterhub/jupyterhub:2.3.1

WORKDIR jupyter
COPY config/jupyterhub_config.py /srv/
COPY config/requirements.txt .

RUN python3 -m pip install --upgrade pip
RUN pip install -r ./requirements.txt

ENTRYPOINT jupyterhub --log-level=DEBUG -f /srv/jupyterhub_config.py
