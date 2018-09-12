
import csv

import requests

user_input = input('Enter you SOCH API key:')

headers = {
    'Accept': 'json'
}

org_generator_url = 'http://www.kulturarvsdata.se/ksamsok/api?method=getServiceOrganization&value=all&x-api={0}'.format(user_input)

def getImageCount(org):
    url = 'http://www.kulturarvsdata.se/ksamsok/api?method=search&query=thumbnailExists=j%20AND%20serviceOrganization="{0}"&x-api={1}'.format(org, user_input)
    r = requests.get(url, headers=headers)
    data = r.json()

    return data['result']['totalHits']

def getImageWithoutLicenseCount(org):
    url = 'http://www.kulturarvsdata.se/ksamsok/api?method=search&query=thumbnailExists=j%20AND%20serviceOrganization="{0}"%20AND%20mediaLicense=""&x-api={1}'.format(org, user_input)
    r = requests.get(url, headers=headers)
    data = r.json()

    return data['result']['totalHits']

r = requests.get(org_generator_url, headers=headers)
data = r.json()

output = open('org-licenses.csv', 'w')
writer = csv.writer(output)

for institution in data['result']['institution']:
    org_full = institution['namnswe']
    org = institution['kortnamn']
    img_good = getImageCount(org)
    img_bad = getImageWithoutLicenseCount(org)
    img_bad_filter = 'http://www.kulturarvsdata.se/ksamsok/api?method=search&query=thumbnailExists=j%20AND%20serviceOrganization="{0}"%20AND%20mediaLicense=""&x-api={1}'.format(org, user_input)

    if img_good:
        precentage = 100 * round(float(img_bad)/float(img_good), 4)
    else:
        precentage = 0
    writer.writerow([org_full, org, img_good, img_bad, precentage, img_bad_filter])

# "org","org_code","items_with_images","missing_licensing","precentage","missing_licensing_filter"
output.close()
print('done')