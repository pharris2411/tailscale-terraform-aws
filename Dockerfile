FROM linuxserver/swag

RUN curl https://pkgs.tailscale.com/stable/tailscale_1.4.5_amd64.tgz --output tailscale_1.4.5_amd64.tgz
RUN tar xvf tailscale_1.4.5_amd64.tgz

RUN mkdir /etc/services.d/tailscale
COPY ./tailscale_init /etc/services.d/tailscale/run

RUN chmod 755 /etc/services.d/tailscale/run

RUN mv /tailscale_1.4.5_amd64/tailscaled /usr/sbin/tailscaled
RUN mv /tailscale_1.4.5_amd64/tailscale /usr/sbin/tailscale
