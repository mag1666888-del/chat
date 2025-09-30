package botstruct

import (
	"strings"

	"github.com/mag1666888-del/chat/pkg/common/constant"
)

func IsAgentUserID(userID string) bool {
	return strings.HasPrefix(userID, constant.AgentUserIDPrefix)
}
