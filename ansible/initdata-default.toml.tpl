algorithm = "sha384"
version = "0.1.0"

[data]
"aa.toml" = '''
[token_configs]
[token_configs.coco_as]
url = "https://kbs-trustee-operator-system.{{ hub_domain }}"

[token_configs.kbs]
url = "https://kbs-trustee-operator-system.{{ hub_domain }}"
cert = """
{{ trustee_cert }}
"""
'''

"cdh.toml"  = '''
socket = 'unix:///run/confidential-containers/cdh.sock'
credentials = []

[kbc]
name = "cc_kbc"
url = "https://kbs-trustee-operator-system.{{ hub_domain }}"
kbs_cert = """ 
{{ trustee_cert }}
"""
'''
