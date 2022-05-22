package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestSubnetAddresses(t *testing.T) {
	t.Parallel()

	options := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/subnet-addresses",
	})

	defer terraform.Destroy(t, options)

	TerraformOutput := func(key string) map[string][]string {
		rawValue := terraform.OutputJson(t, options, key)

		var value map[string][]string

		err := json.Unmarshal([]byte(rawValue), &value)
		require.NoError(t, err)
		return value
	}

	terraform.InitAndApplyAndIdempotent(t, options)

	nowaste_private_subnets := TerraformOutput("nowaste_private_subnets")
	nowaste_public_subnets := TerraformOutput("nowaste_public_subnets")
	nowaste_power_of_two := TerraformOutput("nowaste_power_of_two")
	equalsplit_private_subnets := TerraformOutput("equalsplit_private_subnets")
	equalsplit_public_subnets := TerraformOutput("equalsplit_public_subnets")
	equalsplit_power_of_two := TerraformOutput("equalsplit_power_of_two")

	assert.Equal(t, map[string][]string {
		"private_subnets": []string {"10.0.0.0/17", "10.0.128.0/18", "10.0.192.0/18"},
		"public_subnets": []string {},
		"unused_subnets": []string {},
	}, nowaste_private_subnets)

	assert.Equal(t, map[string][]string {
		"private_subnets": []string {"10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19", "10.0.128.0/20", "10.0.144.0/20"},
		"public_subnets": []string {"10.0.160.0/20", "10.0.176.0/20", "10.0.192.0/20", "10.0.208.0/20", "10.0.224.0/20", "10.0.240.0/20"},
		"unused_subnets": []string {},
	}, nowaste_public_subnets)

	assert.Equal(t, map[string][]string {
		"private_subnets": []string {"10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"},
		"public_subnets": []string {"10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19", "10.0.224.0/19"},
		"unused_subnets": []string {},
	}, nowaste_power_of_two)

	assert.Equal(t, map[string][]string {
		"private_subnets": []string {"10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18"},
		"public_subnets": []string {},
		"unused_subnets": []string {"10.0.192.0/18"},
	}, equalsplit_private_subnets)

	assert.Equal(t, map[string][]string {
		"private_subnets": []string {"10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"},
		"public_subnets": []string {"10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20"},
		"unused_subnets": []string {"10.0.192.0/20", "10.0.208.0/20", "10.0.224.0/20", "10.0.240.0/20"},
	}, equalsplit_public_subnets)

	assert.Equal(t, map[string][]string {
		"private_subnets": []string {"10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"},
		"public_subnets": []string {"10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19", "10.0.224.0/19"},
		"unused_subnets": []string {},
	}, equalsplit_power_of_two)
}
