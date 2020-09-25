FROM bitwalker/alpine-elixir-phoenix:latest
# ENV MIX_ENV prod

WORKDIR /home/shorturl/src

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get --only prod
RUN MIX_ENV=prod mix compile

CMD MIX_ENV=prod mix phx.server


# FROM ubuntu:focal

# RUN apt-get update && \
# 	apt-get install -y python3 python3-pip default-libmysqlclient-dev

# COPY requirements.txt ./

# RUN pip3 install -r requirements.txt

# WORKDIR /home/shorturl/src/


# CMD ["gunicorn", "--error-logfile", "../logs/gunicorn.error.log", "--config", "config.py", "api:app"]
