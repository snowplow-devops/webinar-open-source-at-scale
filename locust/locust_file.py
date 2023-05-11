from locust import HttpUser, TaskSet, task, constant_throughput

import uuid

class GenerateLoadTask(TaskSet):

    @task()
    def track_page_view(self):
        self.client.get("/i?e=pv&dtm=1554988441038&p=pc&url=url1&stm=1554986705000&tv=py-0.8.0&eid=cbdaacbb-7c70-451b-8da1-b9a7846dabcb&page=title1&aid=locust")

    @task()
    def track_struct_event(self):
        self.client.get("/i?se_va=2&se_ca=shop&se_pr=pcs&dtm=1554988441038&se_ac=add-to-basket&tv=py-0.8.0&stm=1554988441000&p=pc&eid=da20b28b-5fc7-454f-b195-7a77db52235c&e=se&aid=locust")

    @task()
    def track_link_click(self):
        self.client.get("/i?e=ue&dtm=1554988987822&tv=py-0.8.0&stm=1554988987000&p=pc&ue_px=eyJkYXRhIjogeyJkYXRhIjogeyJlbGVtZW50Q29udGVudCI6ICJlbGVtZW50IGNvbnRlbnQiLCAiZWxlbWVudFRhcmdldCI6ICJlbGVtZW50IHRhcmdldCIsICJlbGVtZW50SWQiOiAiZWxlbWVudCBpZCAyIiwgInRhcmdldFVybCI6ICJodHRwOi8vbXktdGFyZ2V0LXVybDIvcGF0aCJ9LCAic2NoZW1hIjogImlnbHU6Y29tLnNub3dwbG93YW5hbHl0aWNzLnNub3dwbG93L2xpbmtfY2xpY2svanNvbnNjaGVtYS8xLTAtMSJ9LCAic2NoZW1hIjogImlnbHU6Y29tLnNub3dwbG93YW5hbHl0aWNzLnNub3dwbG93L3Vuc3RydWN0X2V2ZW50L2pzb25zY2hlbWEvMS0wLTAifQ%3D%3D&eid=ff4777a1-254c-4e7c-9e77-f488ef57aeb5&aid=locust")

    @task()
    def track_add_to_cart(self):
        self.client.get("/i?e=ue&dtm=1554989159276&tv=py-0.8.0&stm=1554989159000&p=pc&ue_px=eyJkYXRhIjogeyJkYXRhIjogeyJza3UiOiAiMTIzIiwgImNhdGVnb3J5IjogIkJvb2tzIiwgIm5hbWUiOiAiVGhlIERldmlsJ3MgRGFuY2UiLCAiY3VycmVuY3kiOiAiVVNEIiwgInVuaXRQcmljZSI6IDIzLjk5LCAicXVhbnRpdHkiOiAyfSwgInNjaGVtYSI6ICJpZ2x1OmNvbS5zbm93cGxvd2FuYWx5dGljcy5zbm93cGxvdy9hZGRfdG9fY2FydC9qc29uc2NoZW1hLzEtMC0wIn0sICJzY2hlbWEiOiAiaWdsdTpjb20uc25vd3Bsb3dhbmFseXRpY3Muc25vd3Bsb3cvdW5zdHJ1Y3RfZXZlbnQvanNvbnNjaGVtYS8xLTAtMCJ9&eid=7a9fed57-93c6-4adf-af31-c09e4a8027a1&aid=locust")

    @task()
    def track_site_search(self):
        self.client.get("/i?e=ue&dtm=1554989371245&tv=py-0.8.0&stm=1554989371000&p=pc&ue_px=eyJkYXRhIjogeyJkYXRhIjogeyJ0b3RhbFJlc3VsdHMiOiAyMTUsICJwYWdlUmVzdWx0cyI6IDIyLCAidGVybXMiOiBbInB1bHAgZmljdGlvbiIsICJyZXZpZXdzIl0sICJmaWx0ZXJzIjogeyJuc3dmIjogdHJ1ZX19LCAic2NoZW1hIjogImlnbHU6Y29tLnNub3dwbG93YW5hbHl0aWNzLnNub3dwbG93L3NpdGVfc2VhcmNoL2pzb25zY2hlbWEvMS0wLTAifSwgInNjaGVtYSI6ICJpZ2x1OmNvbS5zbm93cGxvd2FuYWx5dGljcy5zbm93cGxvdy91bnN0cnVjdF9ldmVudC9qc29uc2NoZW1hLzEtMC0wIn0%3D&eid=986afcd9-c2cd-4715-a56f-6be31755128f&aid=locust")

    # Bad Rows
    ## Adapter Failures
    @task()
    def emit_af_not_json(self):
        self.client.post("com.snowplowanalytics.iglu/v1", "not-json")

    @task()
    def emit_af_not_iglu(self):
        body = { "a": "b" }
        self.client.post("com.snowplowanalytics.iglu/v1?schema=myschema", body)

    @task()
    def emit_af_input_data(self):
        body = { "a": "b" }
        self.client.post("com.snowplowanalytics.iglu/v1", body)

    ## Tracker Protocol Violations
    @task()
    def emit_tpv_iglu_error(self):
        body = {"schema": "iglu:com.snowplowanalytics.snowplow/payload_data/jsonschema/1-0-4", "data": "foo"}
        self.client.post("/com.snowplowanalytics.snowplow/tp2", body)

    @task()
    def emit_tpv_criterion_mismatch(self):
        body = {"schema": "iglu:com.snowplowanalytics.snowplow/payload_data/jsonschema/1-0-4", "data": "foo"}
        self.client.post("/com.snowplowanalytics.snowplow/tp2", body)

    @task()
    def emit_tpv_not_json(self):
        self.client.post("/com.snowplowanalytics.snowplow/tp2", "not-json")

    @task()
    def emit_tpv_not_iglu(self):
        body = { "a": "b" }
        self.client.post("/com.snowplowanalytics.snowplow/tp2", body)

    ## Schema Violations
    @task()
    def emit_schema_violation(self):
        self.client.get("/com.snowplowanalytics.snowplow/tp2?e=pp&tv=js-0.13.1&p=web&co=%7B%22schema%22:%22iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0%22,%22data%22:%5B%7B%22schema%22:%22iglu:unexisting%22,%22data%22:%7B%22foo%22:%22bar%22%7D%7D%5D%7D")

    ## Enrichment Failures
    @task()
    def emit_enrichment_failures(self):
        self.client.get("/com.snowplowanalytics.snowplow/tp2?e=pp&tv=js-0.13.1&p=web&co=invalidContext2")


class WebsiteUser(HttpUser):
    tasks = [GenerateLoadTask]
    wait_time = constant_throughput(100)
    max_retries: int = 5
