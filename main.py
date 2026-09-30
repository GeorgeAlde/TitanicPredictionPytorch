import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import data
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler


device = 'cuda' if torch.cuda.is_available() else 'cpu'

x = np.array(data.get_data(), dtype=np.float32)
y = np.array(data.get_answers(), dtype=np.float32)
y = y.reshape(-1, 1)

x_train, x_test, y_train, y_test = train_test_split(
    x,
    y,
    test_size=0.2,
    random_state=42
)



# Scale
scaler = StandardScaler()

x_train = scaler.fit_transform(x_train)
x_test = scaler.transform(x_test)

x_train = torch.tensor(x_train, dtype=torch.float32, device=device)
x_test = torch.tensor(x_test, dtype=torch.float32, device=device)

y_train = torch.tensor(y_train, dtype=torch.float32, device=device)
y_test = torch.tensor(y_test, dtype=torch.float32, device=device)

class NeuralNetwork(nn.Module):
    def __init__(self, in_features, out_features):
        super().__init__()

        self.network = nn.Sequential(
            nn.Linear(in_features, 16),
            nn.ReLU(),
            nn.Linear(16, out_features)
        )

    def forward(self, x):
        return self.network(x)

model = NeuralNetwork(in_features=7, out_features=1).to(device)
learning_rate = 0.01
optimiser = optim.Adam(model.parameters(), lr=learning_rate)
loss_fn = nn.BCEWithLogitsLoss()

perf = []


epochs = 1000
for epoch in range(epochs):
    model.train()
    y_hat = model(x_train)
    loss = loss_fn(y_hat, y_train)

    train_predictions = (torch.sigmoid(y_hat) > 0.5).float()
    train_accuracy = ((train_predictions == y_train).float().mean())
    perf.append(float(train_accuracy.item()))

    



    optimiser.zero_grad()
    loss.backward()
    optimiser.step()

data.write_performance(perf)

model.eval()

with torch.no_grad():

    train_outputs = model(x_train)
    train_predictions = (torch.sigmoid(train_outputs) > 0.5).float()

    train_accuracy = ((train_predictions == y_train).float().mean())

    test_outputs = model(x_test)

    test_predictions = (torch.sigmoid(test_outputs) > 0.5).float()

    test_accuracy = ((test_predictions == y_test).float().mean())

print(f"Train Accuracy: {train_accuracy.item()*100:.2f}%")
print(f"Test Accuracy : {test_accuracy.item()*100:.2f}%")