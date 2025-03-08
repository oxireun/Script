for i = 1, 100000 do
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClaimCoin"):FireServer()
end
