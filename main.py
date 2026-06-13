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
            nn.Linear(7, 16),
            nn.ReLU(),
            nn.Linear(16, 1)
        )

    def forward(self, x):
        return self.network(x)

model = NeuralNetwork(in_features=7, out_features=1).to(device)
learning_rate = 0.01
optimiser = optim.Adam(model.parameters(), lr=learning_rate)
loss_fn = nn.BCEWithLogitsLoss()

epochs = 1000
for epoch in range(epochs):
    y_hat = model(x_train)

    loss = loss_fn(y_hat, y_train)

    optimiser.zero_grad()
    loss.backward()
    optimiser.step()

    if epoch %10 == 0:
        print(f'Epoch {epoch:02d}: Loss = {loss.item():.4f}')