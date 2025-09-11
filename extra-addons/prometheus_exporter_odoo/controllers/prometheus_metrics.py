import logging

from prometheus_client import CollectorRegistry, Counter, Gauge, generate_latest, CONTENT_TYPE_LATEST
from odoo import http
from odoo.http import request, Response

_logger = logging.getLogger(__name__)


class PrometheusController(http.Controller):
    @http.route("/metrics", auth="public", type="http", methods=["GET"])
    def metrics(self, **kwargs):
        """
        Provide Prometheus metrics.
        """
        try:
            registry = CollectorRegistry()
            for metric in request.env["ir.metric"].sudo().search([]):
                if metric.type == "gauge":
                    g = Gauge(metric.name, metric.description, registry=registry)
                    g.set(metric._get_value())
                elif metric.type == "counter":
                    c = Counter(metric.name, metric.description, registry=registry)
                    c.inc(metric._get_value())

            # Retourner la réponse HTTP correctement formatée
            data = generate_latest(registry)
            return Response(data, content_type=CONTENT_TYPE_LATEST)

        except Exception as e:
            _logger.error("Prometheus metrics error: %s", e)
            return Response(str(e), status=500, content_type="text/plain")
