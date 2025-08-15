FROM jupyter/base-notebook:x86_64-python-3.11

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

USER root
# install postgres
RUN pip install --upgrade pip && \
    apt update && apt install -y \
    postgresql-client \
    gcc \
    libpq-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/* && \
    pip install psycopg2

# install requirements
WORKDIR /home/jovyan/source
COPY ./requirements.txt .
RUN pip install --no-cache -r requirements.txt

# change ownership and permissions of the files
RUN chown -R jovyan:users . && chmod 755 -R .

# switch back to unpriviledged user (jovyan)
USER jovyan

# server password is unodostres
ENTRYPOINT ["start-notebook.py", "--PasswordIdentityProvider.hashed_password='argon2:$argon2id$v=19$m=10240,t=10,p=8$iUQEy5LarWih66vFeVjwIg$tw1n42ya7n2uhrmKBfzkQIf7ZcwmfJhVD8KceROHMII'"]
