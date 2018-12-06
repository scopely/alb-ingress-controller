# Copyright 2017[<0;55;12M The Kubernetes Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.11-alpine AS server_builder

RUN apk add bash ca-certificates git gcc g++ libc-dev glide

WORKDIR /go/src/github.com/coreos/alb-ingress-controller

COPY . ./

RUN go version

RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go install -a .

FROM alpine AS server

RUN apk add ca-certificates

COPY --from=server_builder /go/bin/alb-ingress-controller /server

ENTRYPOINT ["/server"]
